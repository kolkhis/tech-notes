# Misc Windows Notes


## See All Applications

Use ++win+r++ to open the run prompt.  
Type in `shell:appsfolder` and hit enter.  
This apps folder shows all installed applications and allows you to uninstall
from the context menu.  


## Disable Telemetry

Open registry editor.  

Navigate to:
- `HKEY_LOCAL_MACHINE`
- `SOFTWARE`
- `POLICIES`
- `MICROSOFT`
- `WINDOWS`
- `DATA COLLECTION`

Right click and create a new registry entry (`DWORD` 32 bit value).  
Set the name to `Allow Telemetry`, and the value to `0`. Then you need to kill
the service.

Type `services` in the start menu, and find the 
`Connected User Experiences and Telemtry` service. Double click and set
"Startup Type" to `Disabled`, then click the `Stop` button if it's running.    
