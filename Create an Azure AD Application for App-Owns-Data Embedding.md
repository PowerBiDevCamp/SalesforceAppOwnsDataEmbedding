# Create an Azure AD Application for App-Owns-Data Embedding

Follow the steps in this document to create a new Azure AD application
for the **SalesforceAppOwnsDataEmbedding** sample project. To complete
these steps, you will require a Power BI environment in which you have a
user account that has been configured as a Power BI Service admin. If
you do not have a Power BI environment for testing, you can create one
for free by following the steps in [Create a Development Environment for
Power BI
Embedding](https://github.com/PowerBiDevCamp/Camp-Sessions/raw/master/Create%20Power%20BI%20Development%20Environment.pdf).

When you login to the Azure portal to create the new Azure AD
application, make sure you log in using a user account in the same
tenant which contains the Power BI reports you'd like to embed. Begin by
navigating to the [App
registration](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps)
page in the Azure portal and click the **New registration** link.

<img src="Images\CreateAzureAdApplication\media\image1.png" style="width:5.08498in;height:1.72078in" alt="Graphical user interface, text, application, email Description automatically generated" />

On the **Register an application** page, enter an application name such
as **Salesforce App-Owns-Data Sample App** and accept the default
selection for **Supported account types** of **Accounts in this
organizational directory only**.

<img src="Images\CreateAzureAdApplication\media\image2.png" style="width:3.16949in;height:1.5117in" />

In the **Redirect URI** section leave the default selection of **Web**
in the dropdown box and leave the textbox to the right of the dropdown
box empty. The reason for leaving this textbox empty is that you do not
need to add a Redirect URI when acquiring app-only access tokens using
Client Credentials Flow. Click the **Register** button to create the new
Azure AD application.

<img src="Images\CreateAzureAdApplication\media\image3.png" style="width:3.8983in;height:1.18104in" />

After creating a new Azure AD application in the Azure portal, you
should see the Azure AD application overview page which displays the
**Application ID**. Note that the ***Application ID*** is often called
the ***Client ID***, so don't let this confuse you. You will need to
copy this Application ID and store it so you can use it later to
configure the project's support for Client Credentials Flow.

<img src="Images\CreateAzureAdApplication\media\image4.png" style="width:4.08244in;height:1.33898in" />

Copy the **Client ID** (aka Application ID) and paste it into a text
document so you can use it later in the setup process. Also copy the Tenant ID and paste that into the text document as well.
Note that the **Client ID** and **Tenant ID** values will be used by
**SalesforceAppOwnsDataEmbedding** project to authenticate as a service
principal.

<img src="Images\CreateAzureAdApplication\media\image5.png" style="width:4.24546in;height:1.11864in" />

Next, you need to create a **Client Secret** for the application. The Client
Secret will act as the application's password when it authenticates
using Client Credentials Flow. Click on the **Certificates & secrets**
link in the left navigation to move to the **Certificates & secrets**
page. On the **Certificates & secrets** page, click the **New client
secret** button as shown in the following screenshot.

<img src="Images\CreateAzureAdApplication\media\image6.png" style="width:4.41525in;height:2.05102in" />

In the **Add a client secret** dialog, add a text description such as
**Test Secret** and then click the **Add** button to create the new
Client Secret.

<img src="Images\CreateAzureAdApplication\media\image7.png" style="width:3.22034in;height:1.13228in" />

Once you have created the **Client Secret**, you should be able to see its
**Value** in the **Client secrets** section.

<img src="Images\CreateAzureAdApplication\media\image8.png" style="width:6.03669in;height:1.22078in" />

Click on the **Copy to clipboard** button to copy the **Client Secret** into
the clipboard.

<img src="Images\CreateAzureAdApplication\media\image9.png" style="width:4.72051in;height:0.81818in" />

Paste the **Client Secret** into the same text document with the **Client ID** and **Tenant ID**.

<img src="Images\CreateAzureAdApplication\media\image10.png" style="width:4.11039in;height:1.47225in" />

Later in the setup process, you will need to configure the
**SalesforceAppOwnsDataEmbedding** project with these values for the
**Client ID**, **Client Secret** and **Tenant ID**. Note that these credentials values will
be tracked in the Salesforce environment using a Custom Metadata Type.

## Configure Service Principal Support in the Power BI Tenant

Next, you need you enable a tenant-level setting for Power BI named
**Allow service principals to use Power BI APIs**. Navigate to the Power
BI Service portal at <https://app.powerbi.com>. Drop down the
**Settings** menu and select the navigation command for the **Admin
portal**.

<img src="Images\CreateAzureAdApplication\media\image11.png" style="width:7.5in;height:1.51736in" />

In the Power BI Admin portal, click the **Tenant settings** link on the
left.

<img src="Images\CreateAzureAdApplication\media\image12.png" style="width:2.59322in;height:1.70106in" />

Move down in the **Developer settings** section and expand the **Allow
service principals to use Power BI APIs** section.

<img src="Images\CreateAzureAdApplication\media\image13.png" style="width:4.89444in;height:3.01736in" />

Note that the Allow service principals to use Power BI APIs setting is
initially set to Disabled.

<img src="Images\CreateAzureAdApplication\media\image14.png" style="width:4.69514in;height:2.27986in" />

Change the setting to **Enabled** and set the **Apply to** setting to
**The entire organization**. Click the **Apply** button to configure the
support you need for a service principal to call the Power BI Service
API.

<img src="Images\CreateAzureAdApplication\media\image15.png" style="width:3.87013in;height:2.97616in" />

You will see a notification indicating it may take up to 15 minutes
until your tenant recognizes your configuration changes.

<img src="Images\CreateAzureAdApplication\media\image16.png" style="width:5.19103in;height:0.92992in" alt="Text Description automatically generated with medium confidence" />

## Configure Service Principal Access to a Power BI Workspace

It is important to understand that a service principal has no default
access to any workspace in a Power BI tenant. Instead, you must add the
service principal for the Azure AD application as a workspace member to
any Power BI workspace that the service principal needs to access. Also
note that when adding a service principal to a Power BI workspace, you
must add the service principal as a workspace member in the role of
either **Admin** or **Member**. Other workspace roles such as
**Contributor** and **Visitor** are not supported for App-Owns-Data
embedding scenarios with a service principal.

Navigate to the Power BI workspace which contains the report you'd like
to embed in your testing. Click the workspace name in the left
navigation to display the workspace summary page. Next, click the
**Access** link to open the **Access** pane where you can configure who
has access to workspace resources.

<img src="Images\CreateAzureAdApplication\media\image17.png" style="width:6.5in;height:2.18194in" />

On the **Access** pane, locate the search box with the caption of
**Enter email address**.

<img src="Images\CreateAzureAdApplication\media\image18.png" style="width:2.71186in;height:1.29292in" />

In the search box with the caption of **Enter email address**, type
*Salesforce* to find the Azure AD application.

<img src="Images\CreateAzureAdApplication\media\image19.png" style="width:3.57291in;height:1.24675in" />

Select the Azure AD application you created earlier. Next, select
**Admin** in the dropdown menu to specify the workspace role and then
click the **Add** button.

<img src="Images\CreateAzureAdApplication\media\image20.png" style="width:3.20339in;height:1.56007in" />

You should now be able to confirm that the Azure AD application you
created earlier has been configured as a **Admin** member of the
workspace.

<img src="Images\CreateAzureAdApplication\media\image21.png" style="width:3.2011in;height:3.07627in" />

If you want the service principal to be able to embed reports for any
other Power BI workspace in the same tenant, follow the same steps to
add the service principal in the workspace role of Admin in those
workspaces as well. 

At this point you have successfully created and
configured the new Azure AD application to support App-Owns-Data embedding.
Remember you will need the **Client ID**, **Client Secret** and **Tenant ID** to configure
**SalesforceAppOwnsDataEmbedding** sample project.

<img src="Images\CreateAzureAdApplication\media\image10.png" style="width:4.11039in;height:1.47225in" alt="Graphical user interface, text, application, email Description automatically generated" />
