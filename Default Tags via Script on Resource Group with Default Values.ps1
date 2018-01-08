 # Create default tags on each resouce group if they do not exist

$requiredTags = @("CostCenter","Category") # Case-Senstive!!!!
$defaultValue = "DEFAULT"

# You could also login with the service principle:
# $secpasswd = ConvertTo-SecureString "{{REPLACE_CLIENT_KEY}}" -AsPlainText -Force
# $mycreds = New-Object System.Management.Automation.PSCredential ("{{REPLACE_CLIENT_ID}}", $secpasswd)
# Login-AzureRmAccount -ServicePrincipal -Tenant {{REPLACE_ENDPOINT}} -Credential $mycreds
Login-AzureRmAccount

$subscriptionList = Get-AzureRmSubscription

# Loop through all subscriptions in list 
foreach ($s in $subscriptionList)
{
    Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId

    # Gets all Azure resource groups
    $ResourceGroups = Get-AzureRmResourceGroup

    foreach ($r in $ResourceGroups)
    {
        $tags = $r.Tags
        if ($tags -eq $null)
        {
            $tags = @{}
        }
        foreach ($requiredTag in $requiredTags) 
        {
            if ($tags.ContainsKey($requiredTags))
            {
                # exists - leave alone
            }
            else
            {
                # add tag
                $tags += @{$requiredTag = $defaultValue}
            }
        } # ($requiredTag in $requiredTags) 

        Set-AzureRmResourceGroup -Name $r.ResourceGroupName -Tag $tags
    } # ($r in $ResourceGroups)

} # ($s in $subscriptionList)




