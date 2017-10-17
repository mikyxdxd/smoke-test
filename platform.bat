call gsutil cp gs://local-builds-resources/GAgent_3.1.2.6_amd64.exe %SystemDrive%\\GAgent_3.1.2.6_amd64.exe
call %SystemDrive%\\GAgent_3.1.2.6_amd64.exe
net stop "GAgent Monitor"
reg delete HKLM\SOFTWARE\Google\GAgent /f
mkdir %SystemDrive%\\AppBridge.SAAS.Platform
mkdir %SystemDrive%\\AppBridge.Management.Windows.UI
call gsutil cp gs://appbridge-build-artifacts/prod/appbridge/appbridge/release_back_end/12/20171005-152557/artifacts/AppBridge.Saas.Platform.zip %SystemDrive%\\AppBridge.SAAS.Platform.zip
call gsutil cp gs://appbridge-build-artifacts/prod/appbridge/appbridge/release_back_end/12/20171005-152557/artifacts/AppBridge.Saas.Platform.zip %SystemDrive%\\AppBridge.Management.Windows.UI.zip
powershell.exe Expand-Archive -Path %SystemDrive%\\AppBridge.SAAS.Platform.zip -DestinationPath %SystemDrive%\\AppBridge.SAAS.Platform
powershell.exe Expand-Archive -Path %SystemDrive%\\AppBridge.Management.Windows.UI.zip -DestinationPath %SystemDrive%\\AppBridge.Management.Windows.UI
REM Enable high performance mode
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
pushd %SystemDrive%\AppBridge.SAAS.Platform
AppBridge.Saas.Platform.exe --install
popd
REM change the delayed automatic start to 1 sec instead of the defaulted 120 sec wait
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\AppBridge.Local.ServiceHost\AutoStartDelay /t REG_DWORD /d 1 /f
REM Configure firewall. Note service="any" is important. If service is set only to appbridge service host, the firewall will block AppBridge service.
netsh.exe advfirewall firewall add rule name="AB Node Platform 80" dir="in" protocol="TCP" localport=80 action="allow" service="any" enable="yes"
netsh.exe advfirewall firewall add rule name="AB Node Platform 443" dir="in" protocol="TCP" localport=443 action="allow" service="any" enable="yes"
shutdown /r /t 0 /f /d p:0:0
