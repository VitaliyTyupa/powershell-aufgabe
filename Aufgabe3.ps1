# File path to store the disk information
$path = "C:\Users\Administrator.ADATUM\"

# Get the server name from user input
$serverName = Read-Host -Prompt "Enter server name"

#Set unic name for server report
$filePath = $path + "diskInfo_" + $serverName + ".txt"

# Request disks
$disks = Get-WmiObject -Class Win32_DiskDrive -ComputerName $serverName

# Check if request to server war successful
if( -not $disks){
    Write-Host "Server $serverName is not available!"
}
else 
{
    # Check if the file exists, create it if not
    if (-not (Test-Path $filePath)) {
        New-Item -Path $filePath -ItemType File
    }

    # Append disk information to the file
    foreach ($disk in $disks) {

        $diskInfo = "DeviceID: $($disk.DeviceID) `
        Model: $($disk.Model) `
        InterfaceType: $($disk.InterfaceType) `
        Size (GB): $([math]::Round($disk.Size / 1GB, 2))"

        Add-Content -Path $filePath -Value $diskInfo
    }
    # Finalizing of process
    Write-Host "Disk information has been saved to $filePath"
}

