import { LightningElement, api, wire } from 'lwc';
import getEmbeddingDataForReport from '@salesforce/apex/PowerBiEmbedManager.getEmbeddingDataForReport';
import powerbijs from '@salesforce/resourceUrl/powerbijs';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';


export default class PowerBiReport extends LightningElement {

  @api WorkspaceId ='';
  @api ReportId ='';
  
    
  @wire(getEmbeddingDataForReport,{
    WorkspaceId: "$WorkspaceId",
    ReportId: "$ReportId"
  }) report;

    renderedCallback() {
       console.log('renderedCallback exectuting');

        Promise.all([ loadScript(this, powerbijs ) ]).then(() => { 

          console.log('renderedCallback 2');
          console.log("this.report", this.report);

            if(this.report.data){

              if(this.report.data.embedUrl && this.report.data.embedToken){
                var reportContainer = this.template.querySelector('[data-id="embed-container"');

                var reportId = this.report.data.reportId;
                var embedUrl = this.report.data.embedUrl;
                var token = this.report.data.embedToken;
              
                var config = {
                  type: 'report',
                  id: reportId,
                  embedUrl: embedUrl,
                  accessToken: token,
                  tokenType: 1,
                  settings: {
                    panes: {
                      filters: { expanded: false, visible: true },
                      pageNavigation: { visible: false }
                    }
                  }
                };
              
                // Embed the report and display it within the div container.
                var report = powerbi.embed(reportContainer, config);

                console.log(powerbi);

              }
              else {
                console.log('no embedUrl or embedToken');
              }
                
              }
              else{
                  console.log('no report.data yet');
              }
       

        });

    }

}