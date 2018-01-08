# Creates a policy that will place default tags on an Azure Resource when the resource is created
# NOTE: This is not tagging the resource group itself

$subscriptionId = "<<REMOVED>>"
Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionId $subscriptionId
$subscriptionScope = "/subscriptions/" + $subscriptionId

$policyName = "Required-Tags"
$policyDescription = "Tags that are required as part of every resource."

# Only allow LRS and GRS storage accounts.
$policyDefinition = New-AzureRmPolicyDefinition `
                        -Name $policyName `
                        -Description $policyDescription `
                        -Policy `
                        '{
                          "$schema": "http://schema.management.azure.com/schemas/2015-10-01-preview/policyDefinition.json",
                          "if": {
                            "exists": false,
                            "field": "tags"
                          },
                          "then": {
                            "effect": "append",
                            "details": [
                              {
                                "field": "tags",
                                "value": { "CostCenter": "DEFAULT", "Category": "DEFAULT" }
                              }
                            ]
                          }
                        }'


New-AzureRmPolicyAssignment `
        -Name $policyName"-Policy-Sub-Scope" `
        -PolicyDefinition $policyDefinition `
        -Scope $subscriptionScope

#Remove-AzureRmPolicyAssignment `
#        -Name $policyName"-Policy-Sub-Scope" `
#        -Scope $subscriptionScope
