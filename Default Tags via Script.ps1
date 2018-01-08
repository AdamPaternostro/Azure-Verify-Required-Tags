$subscriptionId = "<<REMOVED>>"

# Connect to Azure
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId $subscriptionId

New-AzureRmTag -Name "Environment" -Value "Dev"
New-AzureRmTag -Name "Environment" -Value "QA"
New-AzureRmTag -Name "Environment" -Value "Demo"
New-AzureRmTag -Name "Environment" -Value "Prod"

