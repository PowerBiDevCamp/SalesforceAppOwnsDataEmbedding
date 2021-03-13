({
  afterScriptsLoaded: function (component, event, helper) {
    console.log("afterScriptsLoaded");
    var workspaceId = component.get("v.workspaceId");
    var reportId = component.get("v.reportId");

    console.log("afterScriptsLoaded 2B");

    var pattern = new RegExp(
      "^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
      "i"
    );

    console.log("afterScriptsLoaded 5");

    workspaceIdIsValidGuid = pattern.test(workspaceId);
    reportIdIsValidGuid = pattern.test(reportId);

    console.log("afterScriptsLoaded 6");

    if (!workspaceIdIsValidGuid || !reportIdIsValidGuid) {
      component.set(
        "v.errorMessage",
        "Workspace ID and Report ID must be configured as valid GUID!"
      );
    } else {
      console.log("Embedding Report");
      component.set("v.errorMessage", undefined);

      var action = component.get("c.getEmbeddingDataForReport");

      console.log("Embedding Report 2");

      action.setParams({
        WorkspaceId: component.get("v.workspaceId"),
        ReportId: component.get("v.reportId")
      });

      console.log("Embedding Report 3");

      action.setCallback(this, function (response) {
        console.log("callback executing");
        var state = response.getState();
        if (state === "SUCCESS") {
          console.log("callback success");

          var embeddingData = response.getReturnValue();

          console.log("embeddingData", embeddingData);

          if(embeddingData.error){
            component.set("v.errorMessage", embeddingData.error);
          }

          if(embeddingData.embedUrl){
            var reportId = embeddingData.reportId;
            var embedUrl = embeddingData.embedUrl;
            var token = embeddingData.embedToken;
  
            var config = {
              type: "report",
              id: reportId,
              embedUrl: embedUrl,
              accessToken: token,
              tokenType: 1,
              settings: {
                panes: {
                  filters: { expanded: false, visible: false },
                  pageNavigation: { visible: false }
                }
              }
            };
  
            // Embed the report and display it within the div container.
            var embedContainer = component.find("embed-container").getElement();
            var report = powerbi.embed(embedContainer, config);
  
            console.log(report);
  
          }
        }
      });

      console.log("Embedding Report 4");

      $A.enqueueAction(action);

      console.log("Embedding Report 4");
    }
  }
});