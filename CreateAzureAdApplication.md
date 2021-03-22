# Create an Azure AD Application for App-Owns-Data Embedding

Follow these steps in this document to create a new Azure AD application
for the
[**SalesforceAppOwnsDataEmbedding**](https://github.com/PowerBiDevCamp/SalesforceAppOwnsDataEmbedding/tree/main/SalesforceAppOwnsDataEmbedding/force-app/main/default/aura/powerBiReportAura)
sample project in the Azure portal. When you login to the Azure portal,
make sure you log in using a user account in the same tenant which
contains the Power BI reports you'd like to embed.

Begin by navigating to the [App
registration](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps)
page in the Azure portal and click the **New registration** link.

<img src="CreateAzureAdApplication\media\image1.png" style="width:5.08498in;height:1.72078in" alt="Graphical user interface, text, application, email Description automatically generated" />

On the **Register an application** page, enter an application name such
as **Salesforce App-Owns-Data Sample App** and accept the default
selection for **Supported account types** of **Accounts in this
organizational directory only**.

<img src="CreateAzureAdApplication\media\image2.png" style="width:4.43834in;height:2.11688in" />

In the **Redirect URI** section leave the default selection in the
dropdown box to **Web** and leave the textbox to the right of the
dropdown box empty. Note that you do not need to add a Redirect URI when
acquiring app-only access tokens using Client Credentials Flow. Click
the **Register** button to create the new Azure AD application.

<img src="CreateAzureAdApplication\media\image3.png" style="width:5.89418in;height:1.78571in" />

After creating a new Azure AD application in the Azure portal, you
should see the Azure AD application overview page which displays the
**Application ID**. Note that the *Application ID* is often called the
*Client ID*. You will need to copy this Application ID and use it later
to configure the project's support for Client Credentials Flow.

<img src="CreateAzureAdApplication\media\image4.png" style="width:4.71429in;height:1.54622in" />

Copy the application ID and paste it into a text document so you can use
it later. Note that this is the ClientID value that will be used by
**SalesforceAppOwnsDataEmbedding** project.

<img src="CreateAzureAdApplication\media\image5.png" style="width:3.5in;height:0.92222in" />

Next, you need to create a Client Secret for the application which will
act as the application's password when it authenticates using Client
Credentials Flow. Click on the **Certificates & secrets** link in the
left navigation to move to the **Certificates & secrets** page. On the
**Certificates & secrets** page, click the **New client secret** button
as shown in the following screenshot.

<img src="CreateAzureAdApplication\media\image6.png" style="width:6.5in;height:3.01944in" />

In the **Add a client secret** dialog, add a text description such as
Test Secret and then click the **Add** button.

<img src="CreateAzureAdApplication\media\image7.png" style="width:4.4878in;height:1.57792in" />

Once you have created the client secret, you should be able to see its
**Value** in the **Client secrets** section.

<img src="CreateAzureAdApplication\media\image8.png" style="width:6.03669in;height:1.22078in" />

Click on the **Copy to clipboard** button to copy the client secret into
the clipboard.

<img src="CreateAzureAdApplication\media\image9.png" style="width:4.72051in;height:0.81818in" />

Copy the Client Secret into the same text document along with the Client
ID.

<img src="CreateAzureAdApplication\media\image10.png" style="width:4.11039in;height:1.47225in" />

Note that you will need to configure the
**SalesforceAppOwnsDataEmbedding** with these values for the Client ID
and the Client Secret. These credentials values will be tracked in the
Salesforce environment using a Custom Metadata Type.

## Configure Service Principal Support in the Power BI Tenant

Enable the Allow service principals to use Power BI APIs setting and
configure it with the Power BI Apps security group. Navigate to the
Power BI portal at <https://app.powerbi.com>. Drop down the Settings
menu and select the navigation command for the Admin portal.

<img src="CreateAzureAdApplication\media\image11.png" style="width:6.04386in;height:1.11106in" alt="Graphical user interface, text Description automatically generated" />

In the Power BI Admin portal, click the **Tenant settings** link on the
left.

<img src="CreateAzureAdApplication\media\image12.png" style="width:2.54874in;height:1.63706in" alt="Graphical user interface, application Description automatically generated" />

Move down in the Developer settings section and expand the Allow service
principals to use Power BI APIs section.

<img src="CreateAzureAdApplication\media\image13.png" style="width:3.64697in;height:2.21601in" alt="Graphical user interface, application, Teams Description automatically generated" />

Note that the Allow service principals to use Power BI APIs setting is
initially set to Disabled.

<img src="CreateAzureAdApplication\media\image14.png" style="width:2.83882in;height:1.31524in" alt="Graphical user interface, text, application, email Description automatically generated" />

Change the setting to **Enabled** and place your cursor inside the
**Apply to: Specific security groups** textbox.

<img src="CreateAzureAdApplication\media\image15.png" style="width:3.87013in;height:2.97616in" />

You will see a notification indicating it may take up to 15 minutes
until your tenant recognizes your configuration changes.

<img src="CreateAzureAdApplication\media\image16.png" style="width:3.91776in;height:0.70182in" alt="Text Description automatically generated with medium confidence" />

## Configure Service Principal Access to a Power BI Workspace

Add the Azure AD service principal for the Azure AD application to a
Power BI workspace as an administrator.

Click the Dev Camp Lab workspace in the left navigation to display the
workspace summary page.

Click the Access link to open the Access pane where you can configure
who has access to workspace resources.

<img src="CreateAzureAdApplication\media\image17.png" style="width:6.5in;height:2.18194in" />

In the search box with the caption of Enter email address, type
App-Owns-Data to find the Azure AD application.

<img src="CreateAzureAdApplication\media\image18.png" style="width:3.11687in;height:1.46618in" alt="Graphical user interface, application Description automatically generated" />

Select the Azure AD application named App-Owns-Data Sample App.

<img src="CreateAzureAdApplication\media\image19.png" style="width:3.57291in;height:1.24675in" />

xx

Select Admin in the dropdown menu to specify the level of access and
then click the Add button.

<img src="CreateAzureAdApplication\media\image20.png" style="width:3.74675in;height:1.82469in" />

You should now be able to confirm that the App-Owns-Data Sample App has
been configured as a workspace admin.

<img src="CreateAzureAdApplication\media\image21.png" style="width:4.60152in;height:4.42208in" />

Close the Access pane.

<img src="CreateAzureAdApplication\media\image10.png" style="width:4.11039in;height:1.47225in" alt="Graphical user interface, text, application, email Description automatically generated" />
