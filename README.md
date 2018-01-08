# Azure-Verify-Required-Tags
Checks to see if resources and/or resource groups have required tags.  Also, these can be used to set a default set of tags required for a resource.

## Most Oragnaizations want their Azure resources Tagged - This script will audit required tags
In Azure you can tag resource groups and individual resources.  Tags are used for determining how to break down costs (charge back to certain groups), which environments are prod or non-prod or pretty much anything you want.  Tags are simply key-value pairs that can be used for any purpose.

This script will verify that you have your set of required tags on your Azure resources.  Some people just tag at the resource group level and some want each resouce tagged.  There are two scripts for each set of reporting.

You can read more about tags here: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags

## Default Tags 
One thing that Azure does not does not currently allow is to place tags on resources when creating in the Azure portal.  You can place tags when using ARM templates or CLI.  You can create a policy which will place the default (required) tags on the resources (at the time of writing it does not appear policies are putting default tags on a Resource Group) when creating in the portal.  A user will then need to go set these values.  

Another option instead of polices is to create a predefined list of tags the user can select.  In the portal, the user will get a "drop down" of default tags that they can then set the values for: https://docs.microsoft.com/en-us/powershell/module/azurerm.tags/new-azurermtag?view=azurermps-5.1.1

## Warning - Please test before running
These scripts look through ALL the subscriptions you have access.  You should consider only doing a single subscription and you need to test on a small subset to make sure things work they way you want.
