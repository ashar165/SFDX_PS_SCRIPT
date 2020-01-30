function createScratchOrg($scratchOrgAlias, $devhub, $daysAlive, $createNew) {
    
    findExistingOrg
    Write-Host -ForegroundColor Magenta "-- Create scratch org Process started--"
    setAutomationConfigValues
    if ("$orgSearchstatus" -eq 0 -and $createNew -eq $true) {
        deleteScratchOrg
        createNewScratchOrg
    }
    elseif ("$orgSearchstatus" -eq 0 -and $createNew -eq $false) {
        pushCodeToOrg
    }
    else {
        
    }
    Write-Host -ForegroundColor DarkMagenta "-- Create scratch org process over --"

}

function setAutomationConfigValues() {

    Write-Host -ForegroundColor Magenta "-- Setting Automation Config Vars --"

    $automationConfigJsonPath = "$PWD" + "\automation-config.json"  
    $automationConfigVars = Get-Content -Path "$automationConfigJsonPath" | ConvertFrom-Json
    $defenitionFile = $automationConfigVars | Select-Object -Property configFile
    Write-Host $defenitionFile."configFile"
    Write-Host -ForegroundColor Magenta "-- Setting Automation Config Vars done --"

}

function findExistingOrg() {
    Write-Host -ForegroundColor Magenta "-- Finding scratch org with name $scratchOrgAlias --"
    $orgSearchResultJson = (sfdx force:org:display -u $scratchOrgAlias --json)
    Write-Host "org search result: $orgSearchResultJson"
    $prop = 'status'
    $orgSearchResult = $orgSearchResultJson | ConvertFrom-Json 
    $orgSearchstatus = $orgSearchResult.$prop
    if ("$orgSearchstatus" -eq 0) {
        Write-Host "Scratch Org found with name: $scratchOrgAlias"
    }
    else {
        Write-Host "No Scratch Org found with name: $scratchOrgAlias"

    }
    Write-Host -ForegroundColor DarkMagenta "-- Finding scratch org done --"
}

function deleteScratchOrg() {
    Write-Host -ForegroundColor Magenta "-- Deleting scratch org with name $scratchOrgAlias --"
    $orgDeleteJson = (sfdx force:org:delete -u $scratchOrgAlias -p)
    Write-Host "org delete result: $orgDeleteJson"
    $prop = 'status'
    $orgDeleteResult = $orgDeleteJson | ConvertFrom-Json
    $orgDeleteStatus = $orgDeleteResult.$prop
    if ("$orgDeleteStatus" -eq 0) {
        Write-Host "Scratch Org deleted with name: $scratchOrgAlias"
    }
    else {
        Write-Error "Error deleting scratch org with name: $scratchOrgAlias"

    }
    Write-Host -ForegroundColor DarkMagenta "-- Deleting scratch org done --"

}

function createNewScratchOrg() {
    Write-Host -ForegroundColor Magenta "-- Creating scratch org with name $scratchOrgAlias --"

    if ($daysAlive -ile 0 -or $daysAlive -gt 30) {
        Write-Host -ForegroundColor DarkRed "-- WARNING: Incorrect value for parameter daysAlive=$daysAlive `n`t resetting value to default(7)--"
        $daysAlive = 7
    }
    $createScratchOrgJson = (sfdx force:org:create --setalias $scratchOrgAlias --targetdevhubusername $devhub --durationdays $daysAlive --definitionfile ./config/project-scratch-def.json --setdefaultusername)
    Write-Host "create org result: $createScratchOrgJson"
    $prop = 'status'
    $createScratchOrgResult = $createScratchOrgJson | ConvertFrom-Json
    $createScratchOrgStatus = $createScratchOrgResult.$prop
    if ("$createScratchOrgStatus" -eq 0) {
        Write-Host "Scratch Org created sucessfully with name: $scratchOrgAlias"
    }
    else {
        Write-Error "Error creating scratch org"
    }
    Write-Host -ForegroundColor DarkMagenta "-- Creating scratch org done --"

}

function findPackageVersion($packageId){
    $searchPackageVersionResultJson = (sfdx force)
}