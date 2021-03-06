﻿# Windows Azure VPN Enumerator
# (C) 2018 Matt Burrough
# v1.0
#
# Requires the Azure PowerShell cmdlets be installed. 
# See https://github.com/Azure/azure-powershell/ for details.
#
# Before running the script:
#   * Run: Import-Module Azure
#   * Authenticate to Azure in PowerShell using Login-AzureRmAccount
#   * You may also need to run: Set-ExecutionPolicy -Scope Process Unrestricted

$connections = Get-AzureRmResourceGroup | `
    Get-AzureRmVirtualNetworkGatewayConnection

foreach ($connection in $connections)
{
    Get-AzureRmVirtualNetworkGatewayConnection -ResourceGroupName `
        $connection.ResourceGroupName -Name $connection.Name
        
    Get-AzureRmLocalNetworkGateway -ResourceGroupName `
        $connection.ResourceGroupName | `
        Where {$_.Id -eq ($connection.LocalNetworkGateway2.Id)}

    Write-Output "========================================================="
}