# Default path to save the CSV file
$filePath = "C:\Users\Administrator.ADATUM\"

# Set properties to include in the CSV
$properties = 'Name', 'SamAccountName', 'DisplayName', 'EmailAddress', `
                "City", "Company", "Department", "Created", "Enabled"

# Generate unic file name
$fileName = Get-Date -Format yy_MM_dd
$csvFilePath = $filePath + "users_" + $fileName + ".csv"
if (Test-Path $csvFilePath)
{
    $fileName = Get-Date -Format yy_MM_dd_ms
    $csvFilePath = $filePath + "users_" + $fileName + ".csv"
}

# Get users
$adUsers = Get-ADUser -Filter * -Properties $properties | `
            Select-Object $properties

# Export users to a CSV file
$adUsers | Export-Csv -Path $csvFilePath