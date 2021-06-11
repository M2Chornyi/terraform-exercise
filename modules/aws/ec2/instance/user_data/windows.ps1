<powershell>
Install-WindowsFeature -name Web-Server -IncludeManagementTools
#try {
#    mkdir -Force -Path "$env:systemdrive\inetpub\testsite\FcmApi\v1\swagger" ;
#    New-WebAppPool -Name "TestSite" ;
#    New-IISSite -Name "TestSite" -BindingInformation "*:80:" -PhysicalPath "$env:systemdrive\inetpub\testsite" ;
#    echo "<h1>Almost done with my SME</h1>" > "$((Get-Website -Name TestSite).PhysicalPath)\index.html" ;
#    echo "Thisis health check" > "$((Get-Website -Name TestSite).PhysicalPath)\FcmApi\v1\swagger\index.html" ;
#    Set-ItemProperty "IIS:\Sites\TestSite" applicationpool TestSite ;
##    $storeLocation = "cert:\LocalMachine\MY"
##    $certificate = (Get-ChildItem $storeLocation  | Where-Object Subject -CMatch $(hostname)) ;
##    $Thumbprint = $certificate.Thumbprint
##    New-IISSiteBinding -Name "TestSite" -BindingInformation "*:443:" -CertificateThumbPrint $Thumbprint -CertStoreLocation $storeLocation -Protocol https ;
#} catch {
#    Write-Host "[ERROR] IIS installation failed: $_"
#}
</powershell>
