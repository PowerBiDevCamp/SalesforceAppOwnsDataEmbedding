import { LightningElement, wire } from 'lwc';
import getReportEmbeddingData from '@salesforce/apex/PowerBiEmbedManager.getReportEmbeddingData';
import powerbijs from '@salesforce/resourceUrl/powerbijs';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';


export default class PowerBiReport extends LightningElement {
    @wire(getReportEmbeddingData) report;

    renderedCallback() {
       console.log('renderedCallback exectuting');

        Promise.all([ loadScript(this, powerbijs ) ]).then(() => { 

            if(this.report.data){

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
              else{
                  console.log('no report.data yet');
              }
       

        });

    }

}