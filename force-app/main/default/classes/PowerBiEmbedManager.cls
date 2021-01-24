public with sharing class PowerBiEmbedManager {
    
    public static final String TENANT_ID = '2f23c5ea-5a75-41f6-922e-d3392313e61d';
    public static final String CLIENT_ID = '8a026627-2648-445a-8374-db09e09a8668';
    public static final String CLIENT_SECRET = 'OGU5ZjBiY2EtNTk5OC00OTBhLTg2ZjItODhlNGExOTdlMjAx=';
    
    public static final String WORKSPACE_ID = 'ddab987a-7941-4eb5-a084-370d422dfcac';
    public static final String REPORT_ID = '3e75d100-b21a-4129-8e84-6c6e90ccbd7e';

    public PowerBiEmbedManager() {}
    
    // class used to seriliaze request body for client creential flow
    public class ClientCredentialPostData {
        public String client_id;
        public String client_info;
        public string client_secret;
        public String scope;
        public string grant_type;
        public String getPostData(){
          return 'client_id=' + this.client_id + 
                '&client_info=' + this.client_info +
                '&client_secret=' + this.client_secret +
                '&scope=' + this.scope +
                '&grant_type=' + grant_type;
        }
    }

    // class used to deseriliaze response from client creential flow
    public class ClientCredentialResponse {
    	public String access_token;
        public String expires_in;
        public String ext_expires_in;
        public String token_type;
    }

    // class used to deseriliaze response from Power BI API - Get Report
    public class PowerBiReport    {
        public String id { get; set; } 
        public String reportType { get; set; } 
        public String name { get; set; } 
        public String webUrl { get; set; } 
        public String embedUrl { get; set; } 
        public boolean isFromPbix { get; set; } 
        public boolean isOwnedByMe { get; set; } 
        public String datasetId { get; set; } 
   }

    // class used to deseriliaze response from Power BI API - Get Embed Token    
    public class PowerBiEmbedToken    {
        public string token { get; set; } 
        public string tokenId { get; set; } 
        public DateTime expiration { get; set; } 
    }

    // class used to seriliaze report embedding data passed to client components    
    public class PowerBiReportData    {
    	@AuraEnabled
        public String workspaceId { get; set; } 
    	@AuraEnabled
        public String reportId { get; set; } 
    	@AuraEnabled
        public String name { get; set; } 
    	@AuraEnabled
        public String embedUrl { get; set; } 
    	@AuraEnabled
        public String embedToken { get; set; } 
    	@AuraEnabled
        public DateTime embedTokenExpires { get; set; } 
     }
    
     // Requires Remote Site Setting:  https://login.microsoftonline.com 
     public static String getPowerBiAccessToken() {
        String aadTokenEndpoint = 'https://login.microsoftonline.com/' + TENANT_ID + '/oauth2/v2.0/token';
        HttpRequest reqClientCredentialsFlow = new HttpRequest();
        reqClientCredentialsFlow.setMethod('POST');
        reqClientCredentialsFlow.setEndpoint(aadTokenEndpoint);        
        ClientCredentialPostData postData = new ClientCredentialPostData();
		postData.client_id = CLIENT_ID;
		postData.client_info = '1';
		postData.client_secret = CLIENT_SECRET;
		postData.scope = 'https://analysis.windows.net/powerbi/api/.default';
		postData.grant_type = 'client_credentials';
        
        String postBody = postData.getPostData();
        reqClientCredentialsFlow.setBody(postBody);
        reqClientCredentialsFlow.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             
        Http http = new Http();        
        HttpResponse response = http.send(reqClientCredentialsFlow);
 
        String responseJson = response.getBody();
        ClientCredentialResponse responseData = (ClientCredentialResponse)JSON.deserialize(responseJson, ClientCredentialResponse.class);
        String access_token = responseData.access_token;         
        return access_token;
    }
   
    // Requires Remote Site Setting:  https://api.powerbi.com
    @AuraEnabled(cacheable=true)
    public static PowerBiReportData getReportEmbeddingData() {
        System.debug('executing getReportEmbeddingData()...');        

        System.debug('calling Azure AD to acquire app-only access token...');        
        String access_token = getPowerBiAccessToken();
        
        System.debug('calling Power BI Service API to get report data...');        
        
        HttpRequest reqGetReport = new HttpRequest();
        reqGetReport.setMethod('GET');
        String urlGetReport = 'https://api.powerbi.com/v1.0/myorg/groups/' + WORKSPACE_ID + '/reports/' + REPORT_ID;
        reqGetReport.setEndpoint(urlGetReport);
        reqGetReport.setHeader('Authorization', 'Bearer ' + access_token);
        
  
        Http http = new Http();        
        HttpResponse response = http.send(reqGetReport);
        
        System.debug('status code: ' + response.getStatusCode());
        
        if(response.getStatusCode()!=200){
            System.debug('ERROR --- Getting Report Data --- ERROR');
            System.debug('Status Code: ' + response.getStatusCode());
        }            
            
        String responseJson = response.getBody();
        PowerBiReport powerBiReport = (PowerBiReport)JSON.deserialize(responseJson, PowerBiReport.class);
        
        // you now have powerBiReport object with data from Power BI Service API call
        System.debug('id: ' + powerBiReport.id);        
        System.debug('reportType: ' + powerBiReport.reportType);        
        System.debug('name: ' + powerBiReport.name);  
        System.debug('webUrl: ' + powerBiReport.webUrl);        
        System.debug('embedUrl: ' + powerBiReport.embedUrl);        
        System.debug('isFromPbix: ' + powerBiReport.isFromPbix);        
        System.debug('isOwnedByMe: ' + powerBiReport.isOwnedByMe);        
        System.debug('datasetId: ' + powerBiReport.datasetId);        

    
        System.debug('calling Power BI Service API to embed token...');        
        HttpRequest reqGetEmbedToken = new HttpRequest();
        reqGetEmbedToken.setMethod('POST');
        String urlGetEmbedToken = 'https://api.powerbi.com/v1.0/myorg/groups/' + WORKSPACE_ID + '/reports/' + REPORT_ID + '/GenerateToken';
        reqGetEmbedToken.setEndpoint(urlGetEmbedToken);
        reqGetEmbedToken.setHeader('Authorization', 'Bearer ' + access_token);
   
        reqGetEmbedToken.setBody('{"accessLevel": "View", "datasetId": "' + powerBiReport.datasetId + '"}');
        
        HttpResponse responseEmbedToken = http.send(reqGetEmbedToken);

        if(responseEmbedToken.getStatusCode()!=200){
            System.debug('ERROR --- Getting Embed Token --- ERROR');
            System.debug('Status Code: ' + responseEmbedToken.getStatusCode());
        }            
        
        PowerBiEmbedToken embedToken = (PowerBiEmbedToken)JSON.deserialize(responseEmbedToken.getBody(), PowerBiEmbedToken.class);
        
        // you now have embedToken object containing embed token from Power BI Service API 
        System.debug('EmbedToken: ' + embedToken.token);        
        System.debug('EmbedToken ID: ' + embedToken.tokenId);        
        System.debug('expiration: ' + embedToken.expiration);
        
        // create object with report embedding data to pass back to client
        PowerBiReportData powerBiReportData = new PowerBiReportData();
        
        powerBiReportData.workspaceId = WORKSPACE_ID;
        powerBiReportData.reportId = REPORT_ID;
        powerBiReportData.name = powerBiReport.name;
        powerBiReportData.embedUrl = powerBiReport.embedUrl;
        powerBiReportData.embedToken = embedToken.token;
        powerBiReportData.embedTokenExpires = embedToken.expiration;
        
        return powerBiReportData;            
        
    }

}