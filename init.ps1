param (
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "initParamSet")]
    [string]$repoUrl
    <#[Parameter(Mandatory = $true, Position = 1, ParameterSetName = "initParamSet")]
    [string]$scratchOrgalias,
    [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "initParamSet")]
    [string]$devhub
    [Parameter(Mandatory = $true, Position = 3, ParameterSetName = "initParamSet")]
    [string]$artifactName,
    [Parameter(Mandatory = $true, Position = 4, ParameterSetName = "initParamSet")]
    [int]$scratchOrgDays,
    [Parameter(Mandatory = $true, Position = 5, ParameterSetName = "initParamSet")]
    [bool]$createNew 
    #>
    
)

Write-Host -ForegroundColor Cyan "`nFn -> INIT -> Enter"

Write-Host -ForegroundColor Blue "`n-- Importing modules --"

Write-Host -ForegroundColor Yellow "GitManager"
. ./GitManager.ps1

Write-Host -ForegroundColor Yellow "UtitlityManager"
. ./UtilityManager.ps1

Write-Host -ForegroundColor DarkBlue "--Importing modules Done --"

$initParamSet = @{
    repoUrl = "$repoUrl"
    <#scratchOrgalias = "$scratchOrgalias"
    devhub          = "$devhub"
    artifactName = "$artifactName"
    scratchOrgDays = "$scratchOrgDays"
    createNew = "$createNew" #>
}
Write-Host -ForegroundColor Green "`n-- Processing Paramaters --"
$initParamSet | Sort-Object -Property name | Format-Table -AutoSize
Write-Host -ForegroundColor DarkGreen "-- Processing Paramaters Done--"


$wshell = New-Object -ComObject Wscript.Shell
$correctDetails = $wshell.Popup("Repository URL: $repoUrl", 0, "Confirm Details", 4 + 32)

if ($correctDetails -eq 6) {
    gitClone -repUrl "$repoUrl"
    $projectLocation = "$PWD" + "/techchallenge_2k18"    
    openVsCode -targetLocation "$projectLocation"
    createScratchOrg
    
}
elseif ($correctDetails -eq 7) {
    Write-Error  "Terminating script. Restart and provide correct details $initParamSet"  
}
else {
    Write-Error "Terminating script. Unexpected input. $initParamSet"
}

Write-Host -ForegroundColor DarkCyan "Fn -> INIT -> Exit"




