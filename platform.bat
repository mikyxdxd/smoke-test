call %SystemDrive%\\GAgent_3.1.2.6_amd64.exe
net stop "GAgent Monitor"
reg delete HKLM\SOFTWARE\Google\GAgent /f
mkdir %SystemDrive%\\Starting
call gsutil cp gs://appbridge-build-artifacts/prod/appbridge/appbridge/release_back_end/17/20171103-083154/artifacts/AppBridge_Migration_Platform_Installer_2_0_0_22.exe %SystemDrive%\\AppBridge_Migration_Platform_Installer.exe
REM Enable high performance mode
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
pushd %SystemDrive%
mkdir %SystemDrive%\\install
%SystemDrive%\\AppBridge_Migration_Platform_Installer.exe --install /VERYSILENT /norestart
mkdir %SystemDrive%\\installed
popd


sc config "AppBridge.Local.ServiceHost" start=auto
sc start "AppBridge.Local.ServiceHost"

netsh advfirewall set AllProfiles state off
