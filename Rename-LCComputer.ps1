param(
    [string] $ServerPrefix,
    [pscredential] $credentials,
    [string] $DCIpAddress
)
Write-Output "ServerPrefix: $ServerPrefix"
$names = Invoke-Command -ComputerName $DCIpAddress -ScriptBlock {param($searchString) Get-ADComputer -Filter * | Where{$_.Name -like "$($searchString)*"} | select Name} -Credential $credentials -ArgumentList $ServerPrefix
Write-Output "Names found: $names"
if($names -eq $null){$hostname = $ServerPrefix + "-01"}
else{
    $last = ($names | Sort-Object -Property Name -Descending)[0].Name
    [int] $num = $last.Substring($last.Length-2)
    $num++
    if($num -lt "10"){$hostname = $last.Substring(0,$last.Length-2) + "0" + [string]$num}
    else {$hostname = $last.Substring(0,$last.Length-2) + [string]($num)}
}
Write-Output "Hostname set to: $hostname"
Rename-Computer -NewName $hostname -Restart