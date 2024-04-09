#Backtrace I/O Symbols upload Powershell Script
#Run script to upload .pdb/.dll/.exe files to Backtrace I/O API 

 param (
    [Parameter(Mandatory=$true)][string]$server,
	[Parameter(Mandatory=$true)][string]$output,
    [Parameter(Mandatory=$true)][string]$binaryDirectory,
    [Parameter(Mandatory=$true)][string]$platform
 )

 #generating archive
 $includes=  ""
 switch($platform)
 {
    "Win32" { $includes = "*.pdb" }
    "x64" { $includes = "*.dll", "*.pdb", "*.exe" }
    "default" { $includes= "*" }
}

$files = Get-ChildItem $binaryDirectory\* -Include $includes 

$destinationArchiveName = "${output}-symbols.zip"
Write-Output $destinationArchiveName
$destinationPath = Join-Path $binaryDirectory -ChildPath $destinationArchiveName
if (Test-Path $destinationArchiveName)
{
    Write-Output "Old archive exists. Deleting...."
    Remove-Item $destinationArchiveName
}

Compress-Archive -Path $files -DestinationPath $destinationPath -CompressionLevel Optimal -Force


#creating web request
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $server -Method Post -InFile $destinationPath   -ContentType 'multipart/form-data' 
  