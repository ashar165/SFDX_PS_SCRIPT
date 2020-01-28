function openVsCode {
    ($targetLocation)
    Write-Host -ForegroundColor Magenta "-- Opening VS Code at location: $projectLocation --"
    code "$projectLocation"

    Write-Host -ForegroundColor DarkMagenta "-- Opening VS Code Done --"
}