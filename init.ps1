param (
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName = "initParamSet")]
    [string]$repoUrl,
    [Parameter(Mandatory = $true, Position = 2, ParameterSetName = "initParamSet")]
    [int]$daysAlive,
    [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "initParamSet")]
    [string]$scratchOrgAlias,
    [Parameter(Mandatory = $true, Position = 3, ParameterSetName = "initParamSet")]
    [string]$artifactName
    <#[Parameter(Mandatory = $true, Position = 4, ParameterSetName = "initParamSet")]
    [string]$devhub,
    [Parameter(Mandatory = $true, Position = 5, ParameterSetName = "initParamSet")]
    [bool]$createNew 
    #>
    
)

Write-Host -ForegroundColor Cyan "`n-- Here We Go --"



Write-Host -ForegroundColor Yellow "`n-- Importing modules --"

Write-Host "GitManager"
. ./GitManager.ps1

Write-Host "UtitlityManager"
. ./UtilityManager.ps1
Write-Host "SfdxManager"
. ./SfdxManager.ps1

Write-Host -ForegroundColor DarkYellow "--Importing modules Done --"

$devhub = "aashish1710sharma-hvrc@force.com"
$createNew = $true

$initParamSet = @{
    repoUrl         = "$repoUrl"
    daysAlive       = "$daysAlive"
    scratchOrgAlias = "$scratchOrgAlias"
    artifactName    = "$artifactName"
    devhub          = "$devhub"
    createNew       = "$createNew" 
}
Write-Host -ForegroundColor Yellow "`n-- Processing Paramaters --"
$initParamSet | Sort-Object -Property name | Format-Table -AutoSize
Write-Host -ForegroundColor DarkYellow "-- Processing Paramaters Done--"


$wshell = New-Object -ComObject Wscript.Shell
$correctDetails = $wshell.Popup("Repository URL: $repoUrl", 0, "Confirm Details", 4 + 32)

if ($correctDetails -eq 6) {
    gitClone -repUrl "$repoUrl"
    Set-Location "$PWD\SFDX_PS_SAMPLE_REPO"
    $artifactJsonPath = "$PWD" + "\artifacts.json"   

    Write-Host -ForegroundColor Yellow "`n-- Processing Roots Json --"
    $artifacts = Get-Content -Path "$artifactJsonPath" | ConvertFrom-Json | Select-Object -expand artifacts
    $artifacts | ForEach-Object($_) { 
        if ($_.artifactName -eq $artifactName) {
            $root = $_.root
        }
    }
    Write-Host "Root : $root"
    Write-Host -ForegroundColor DarkYellow "-- Processing Roots Json Done--"

    Set-Location "$PWD$root"

    <#foreach ($eachArtifact in $artifacts) {
        Write-Host $eachArtifact
        foreach ($prop in $artifact) {
            Write-Host $eachArtifact.prop.name
            Write-Host $eachArtifact.prop.value
        }
    }#>
    openVsCode -targetLocation "$projectLocation"
    createScratchOrg -scratchOrgAlias "$scratchOrgAlias" -devhub "$devhub" -daysAlive "$daysAlive" -createNew="$createNew"
    
}
elseif ($correctDetails -eq 7) {
    Write-Error  "`nTerminating script. Restart and provide correct details $initParamSet"  
}
else {
    Write-Error "`nTerminating script. Unexpected input. $initParamSet"
}

Write-Host -ForegroundColor DarkCyan "`n-- See you soon! --"




