<# 
 .Synopsis
  Produces the Azure AD Configuration reports required by the Azure AD assesment
 .Description
  This cmdlet reads the configuration information from the target Azure AD Tenant and produces the output files 
  in a target directory

 .PARAMETER OutputDirectory
    Full path of the directory where the output files will be generated.

.EXAMPLE
   .\Get-AADAssessmentReports -OutputDirectory "c:\temp\contoso" 

#>

Function Invoke-AADExporter {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    $itemsToExport = @{
        "Get-AADExportOrganization"     = "organization.json"
    }

    $totalExports = $itemsToExport.Count
    $processedItems = 0

    foreach ($item in $itemsToExport.GetEnumerator()) {
        $functionName = $item.Name
        $outputFileName = Join-Path -Path $Path -ChildPath $item.Value
        $percentComplete = 100 * $processedItems / $totalExports
        Write-Progress -Activity "Reading Azure AD Configuration" -CurrentOperation "Exporting $functionName" -PercentComplete $percentComplete

        Write-Host "exporting " $functionName
        Invoke-Expression -Command $functionName | ConvertTo-Json -depth 100 | Out-File $outputFileName

        $processedItems++
    }

    $percentComplete = 100 * $processedItems / $totalExports            
}