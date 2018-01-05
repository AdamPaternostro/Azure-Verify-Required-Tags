# Generate a CSV for Azure Resources that are missing a required tag or the tag is set to a default value

# Fill this out
$requiredTags = @("CostCenter","Category") # Case-Senstive!!!!
$csvPath = [Environment]::GetFolderPath("Desktop") + "\MissingResouceTagsInAzure.csv"
$defaultValue = "DEFAULT"

# You could also login with the service principle:
# $secpasswd = ConvertTo-SecureString "{{REPLACE_CLIENT_KEY}}" -AsPlainText -Force
# $mycreds = New-Object System.Management.Automation.PSCredential ("{{REPLACE_CLIENT_ID}}", $secpasswd)
# Login-AzureRmAccount -ServicePrincipal -Tenant {{REPLACE_ENDPOINT}} -Credential $mycreds
# Login-AzureRmAccount

$subscriptionList = Get-AzureRmSubscription

# Loop through all subscriptions in list 
foreach ($s in $subscriptionList)
{
    Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId

    # If you just tag your Resource Groups then you would need to make some changes.
    # e.g. You would change Get-AzureRmResource to Get-AzureRmResourceGroup (this command returns the tags directly too)

    # Gets all Azure resources
    $Resources = Get-AzureRmResource

    foreach ($r in $Resources)
    {
        try 
        {
            $tags = (Get-AzureRmResource -Name $r.Name -ResourceGroupName $r.ResourceGroupName -ResourceType $r.ResourceType).Tags
        }
        catch
        {
            # Bad Azure Resource?
            foreach ($requiredTag in $requiredTags)
            {
                New-Object -TypeName PSObject -Property @{
                            SubscriptionId = $s.SubscriptionId
                            SubscriptionName = $s.SubscriptionName
                            ResourceGroupName = $r.ResourceGroupName
                            ResourceType = $r.ResourceType
                            Name = $r.Name
                            MissingTag = $requiredTag                            
                            } | Select-Object SubscriptionId, SubscriptionName, ResourceGroupName, ResourceType, Name, MissingTag | Export-Csv -Path $csvPath -Append -Force -NoTypeInformation
            }
        }
       
        foreach ($requiredTag in $requiredTags) 
        {
            # Debug
            # $outputText = $r.ResourceGroupName + "," + $r.Name + "," + $r.ResourceType +"," + $requiredTag + "`r"
            # Write-Output $outputText
            
            if ($tags -eq $null)
            {
                # No tags, so it must be missing
                New-Object -TypeName PSObject -Property @{
                            SubscriptionId = $s.SubscriptionId
                            SubscriptionName = $s.SubscriptionName
                            ResourceGroupName = $r.ResourceGroupName
                            ResourceType = $r.ResourceType
                            Name = $r.Name
                            MissingTag = $requiredTag                            
                            } | Select-Object SubscriptionId, SubscriptionName, ResourceGroupName, ResourceType, Name, MissingTag | Export-Csv -Path $csvPath -Append -Force -NoTypeInformation
             }
            else
            {
                # Check hashtable for tag
                if ($tags.ContainsKey($requiredTag) -eq $false)
                {
                    New-Object -TypeName PSObject -Property @{
                                SubscriptionId = $s.SubscriptionId
                                SubscriptionName = $s.SubscriptionName
                                ResourceGroupName = $r.ResourceGroupName
                                ResourceType = $r.ResourceType
                                Name = $r.Name
                                MissingTag = $requiredTag                            
                                } | Select-Object SubscriptionId, SubscriptionName, ResourceGroupName, ResourceType, Name, MissingTag | Export-Csv -Path $csvPath -Append -Force -NoTypeInformation
                }
                else
                {
                    # Make sure the tag is not a DEFAULT value
                    if ($tags[$requiredTag] -eq $defaultValue)
                    {
                        New-Object -TypeName PSObject -Property @{
                                    SubscriptionId = $s.SubscriptionId
                                    SubscriptionName = $s.SubscriptionName
                                    ResourceGroupName = $r.ResourceGroupName
                                    ResourceType = $r.ResourceType
                                    Name = $r.Name
                                    MissingTag = $requiredTag                            
                                    } | Select-Object SubscriptionId, SubscriptionName, ResourceGroupName, ResourceType, Name, MissingTag | Export-Csv -Path $csvPath -Append -Force -NoTypeInformation
                        }
                }
            } # ($tags -eq $null)
        } # ($requiredTag in $requiredTags)
       

    } # ($r in $Resources)

} #foreach ($s in $subscriptionList)

