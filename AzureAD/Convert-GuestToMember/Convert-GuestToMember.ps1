### First: identify User
### Create an immutableId for the user.
$SamAccountName = read-Host "Type in the SamAccountName of the user"
$ADGuidUser = Get-ADUser $SamAccountName | Select Name,ObjectGUID
Echo "Creating a immutableId for $($ADGuidUser.Name)"
$UserimmutableID = [System.Convert]::ToBase64String($ADGuidUser.ObjectGUID.tobytearray())
Echo "immutableId is: $($UserimmutableID)"

### Second: Set ImmutableId for Cloud Account
Connect-MsolService
$UPN = read-Host "Type in the full UPN (like 'tim.tester_wsi.one#EXT#@TENANTNAME.onmicrosoft.com') of the user. Visit portal.azure.com to get the full UPN."
Set-MSOLuser -UserPrincipalName $UPN -ImmutableID $UserimmutableID
Echo "Updated $UPN with the immutableId: $UserimmutableID from ADUser $($ADGuidUser.Name)"
Echo "Wait until next AD sync or start ADSyncCycle with polityType Delta"
pause
