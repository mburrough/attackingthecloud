# Azure Key Vault Enumerator
# (C) 2018-2019 Matt Burrough
# v1.2

# Requires the Azure PowerShell cmdlets be installed. 
# See https://github.com/Azure/azure-powershell/ for details.

# Before running the script:
#   * Run: Import-Module Azure
#   * Authenticate to Azure in PowerShell
#   * You may also need to run: Set-ExecutionPolicy -Scope Process Unrestricted

$keyvaults = Get-AzureRmKeyVault
foreach($keyvault in $keyvaults) 
{
	$vaultName = $keyvault.VaultName
    Write-Output "----- Vault: $vaultName -----"
	
    Try 
    {
        $secrets = Get-AzureKeyVaultSecret -VaultName $vaultName -ErrorAction Stop
		
		if($secrets -ne $null)
        {
            Write-Output "SecretName: SecretValueText"
            foreach ($secret in $secrets) 
            {
                $value = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $secret.Name
                Write-Output "$($secret.Name): $($value.SecretValueText)"
            }
        }

		$keys = Get-AzureKeyVaultKey -VaultName $vaultName -ErrorAction Stop
        if($keys -ne $null)
        {
            Write-Output ""
			Write-Output "KeyName: KeyValue"
            foreach ($key in $keys) 
            {
                $value = Get-AzureKeyVaultKey -VaultName $vaultName -KeyName $key.Name
                Write-Output "$($key.Name): $($value.Key.ToString())"
            }
        }
		
		$certs = Get-AzureKeyVaultCertificate -VaultName $vaultName
		if($certs -ne $null)
		{
			foreach ($cert in $certs) 
			{
				$cn = $cert.Name
				$c = Get-AzureKeyVaultCertificate -VaultName $vaultName -Name $cn
				$x509 = $c.Certificate
				Write-Output $c
				$privkey = (Get-AzureKeyVaultSecret -VaultName $vaultName -Name $cn).SecretValueText
				Write-Output "Private Key:"
				Write-Output $privkey
				Write-Output ""
				Write-Output "Exporting Public Key to $cn.cer..."
				Export-Certificate -Type CERT -Cert $x509 -FilePath "$cn.cer"
				Write-Output "Exporting Private Key to $cn.pfx..."
				$privbytes = [Convert]::FromBase64String($privkey)
				[IO.File]::WriteAllBytes("$pwd\$cn.pfx", $privbytes)
				Write-Output "----------------------------------------------"
			}
		}
    }
    Catch
    {
        Write-Output "Could not read from vault."
    }
	
    Write-Output ""
}
Write-Output ""
