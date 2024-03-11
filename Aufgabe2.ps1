# Path to the CSV file
$csvFilePath = "E:\Mod07\Labfiles\users.csv"

# Init users
$users = Import-Csv -Path $csvFilePath

# Handle each user in list
foreach ($user in $users) {

    # Init new user attributes
    $name = $user.First + " " + $user.Last
    $department = $user.Department
    $emailAddress = $user.First + "." + $user.Last + "@adatum.com"
    $initials = $user.First[0] + $user.Last[0]    
    $OUPfad = "OU=" + $user.Department + ",DC=Adatum,DC=com"
    $samAccountName = $user.UserID
    
    # Check if User already exists
    if (Get-ADUser -Filter {SamAccountName -eq $samAccountName})
    {
        write-Warning "User with Name: $name already exists"
    } else {

        # Create the user 
        New-ADUser -Name $name `
         -Department $department `
         -EmailAddress $emailAddress `
         -DisplayName $name `
         -GivenName $user.First `
         -UserPrincipalName $emailAddress `
         -Surname $user.last `
         -SamAccountName $samAccountName `
         -Company "Adatum" `
         -Initials $initials `
         -Path $OUPfad `

        # Add user to group
        $identity = "CN=$department,OU=$department,DC=Adatum,DC=com"
        Add-ADGroupMember -Identity $identity -Members $samAccountName
    }

}