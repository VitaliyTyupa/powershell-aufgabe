# File path to store user details
$filePath = "C:\Users\Administrator.ADATUM\InactiveUsers_Log.txt"
 
# Define Date for 35 days before today
$ExpiredDate = (Get-Date).AddDays(-35)

# Define OU where inactive users will be moved
$inactiveOU = "OU=InactiveUsers,DC=Adatum,DC=com"

# Get only active users with LastLogonDate <= $ExpiredDate
$inactiveUsers = Get-ADUser -Filter { LastLogonDate -le $ExpiredDate -and Enabled -eq $true } -Properties LastLogonDate, Enabled

# Move inactive users to the inactive OU and log their details
if ($inactiveUsers.Count -gt 0) {
    foreach ($user in $inactiveUsers) {
        $deactivationDate = Get-Date
        $userSamAccountName = $user.SamAccountName

        # Move user to the inactive OU
        Move-ADObject -Identity $user -TargetPath $inactiveOU

        # Disable the user account
        Disable-ADAccount -Identity $userSamAccountName

        # Log user details in the file
        $logInfo = "Deactivation Date: $deactivationDate | User SamAccountName: $userSamAccountName"
        Add-Content -Path $filePath -Value $logInfo
    }

    Write-Host "$inactiveUsers.Count users have been moved to $inactiveOU and their details have been logged in $filePath"
} else {
    Write-Host "No users found that meet the criteria for deactivation."
}