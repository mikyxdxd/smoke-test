call gsutil cp gs://local-builds-resources/GAgent_3.1.2.6_amd64.exe %SystemDrive%\\GAgent_3.1.2.6_amd64.exe
call %SystemDrive%\\GAgent_3.1.2.6_amd64.exe
net stop "GAgent Monitor"
reg delete HKLM\SOFTWARE\Google\GAgent /f

call gsutil cp gs://appbridge-build-artifacts/prod/appbridge/appbridge/release_back_end/12/20171005-152557/artifacts/AppBridge_Migration_Platform_Installer_2_0_0_20.exe %SystemDrive%\\AppBridge_Migration_Platform_Installer.exe
REM Enable high performance mode
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
pushd %SystemDrive%
AppBridge_Migration_Platform_Installer.exe --install /VERYSILENT /norestart

popd

sc config "AppBridge.Local.ServiceHost" start=auto
netsh.exe advfirewall firewall add rule name="AB Node Platform 5131" dir="in" protocol="TCP" localport=5131 action="allow" service="any" enable="yes"
netsh.exe advfirewall firewall add rule name="AB Node Platform 443" dir="in" protocol="TCP" localport=443 action="allow" service="any" enable="yes"
shutdown /r /t 0 /f /d p:0:0
