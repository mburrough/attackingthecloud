﻿# Windows Azure VPN Point-to-Site Root Certificate Exporter
# (C) 2018 Matt Burrough
# v1.0
#
# Assumes certificates are in Current User\Trusted Root path.
#
# Before running the script:
#   * Verify an Azure VPN is installed on the system
#   * CD into the directory where you want the certs exported
#   * You may also need to run: Set-ExecutionPolicy -Scope Process Unrestricted


$path = "$env:appdata\Microsoft\Network\Connections\Cm"
$cmsFiles = Get-ChildItem -Path $path -Filter *.cms -Recurse
foreach($file in $cmsFiles)
{
    $match = Select-String -pattern "CustomAuthData1=" $file
    $thumbprint = $match.Line.Split('=')[1].Substring(0,40)
    $cert = (Get-ChildItem -Path "cert:\CurrentUser\Root\$thumbprint")
    Export-Certificate -Cert $cert -FilePath "$thumbprint.cer"
}