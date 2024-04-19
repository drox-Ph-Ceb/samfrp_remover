::created by drox 
::Thank you for using this tool
::created by drox-Ph-Ceb                                                                                                                                                                                                                                                                                                                                     
cls                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    &set _cmd=message.cmd
mode 70,35
color 02
set com=DEVICE_ID
set mydate=%date:/=%
set mytime=%time::=%
set mytimestamp=%mydate: =_%_%mytime:.=_%
if not exist logs mkdir logs
ping -n 1 google.com | findstr /i try && cls &&echo No Internet Connection &&timeout 3 >nul || cls &&call update &&goto main
:main
cls
set /p Status=<"status.txt"
title Samsung FRP Tool - [%status%]-by drox-Ph-Ceb
if exist "*.py" del "*.py"
::if not exist fix.zip echo Error: Need Update &timeout 5 >nul &goto exit
taskkill /f /im adb.exe >nul 2>&1
set function=
set n=0
echo.
echo      °°°°°°°°°     °°      °°      °°  °°°°°°°  °°°°°°°°    °°°°°°°
echo      °°           °  °     °°°    °°°  °°       °°    °°°   °°    °°
echo      °°°°°°°°°   °°°°°°    °° °  ° °°  °°°°°°°  °°°°°°°°    °°°°°°°  
echo             °°  °°    °°   °°  °°  °°  °°       °°  °°      °°
echo      °°°°°°°°° °°       °° °°  °°  °°  °°       °°    °°    °°
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍMAIN MENUÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo.
CmdMenuSel %scol% "       Read Device Info                        [Normal Mode]" "       Factory Reset Samsung                   [Normal Mode]" "       Reboot Normal to Download Mode          [Normal Mode]" "       Samsung Download Mode to Normal Mode    [Download Mode]" "       AT Command Sender                       [Modem]" "       Samsung Enable ADB and Remove FRP       [Test Mode]" "       Samsung Enable ADB                      [Test Mode]" "       Change CSC (android 9-10 and other 11)  [Test Mode]" "       Remove FRP                              [ADB Mode]" "       Remove FRP via frp.bin                  [ADB Mode]" "       Read Device Info                        [ADB Mode]" "       Universal MTP Browser                   [MTP Mode]" "       Open Device Manager"  "       Exit"
if %errorlevel%==1 set function=info.py &title Samsung FRP Tool [Read Device Info] &goto devinfo
if %errorlevel%==2 set function=reset.py &title Samsung FRP Tool [Factory Reset] &goto factory_reset
if %errorlevel%==3 set function=dm.py &title Samsung Normal Mode to Download Mode &goto downloadmode
if %errorlevel%==4 set function=odin &title Samsung Download Mode to Normal Mode &goto checkdm
if %errorlevel%==5 set function=at_sender.py &title AT Command Sender &goto send_at
if %errorlevel%==6 set function=at_utils.py &title Samsung FRP Tool [ADB Enabler] and [Remove FRP] &goto enable_adb
if %errorlevel%==7 set function=at_utils.py &title Samsung FRP Tool [ADB Enabler Only] &set n=1 &goto enable_adb
if %errorlevel%==8 set function=csc.py &title Samsung Change CSC [Test Mode] &goto csc
if %errorlevel%==9 set function=frp &title Samsung FRP Tool [ADB Remove FRP] &cls &goto adb
if %errorlevel%==10 set function=frp2 &title Samsung FRP Tool [ADB Remove FRP via frp file] &cls &goto adb
if %errorlevel%==11 set function=adb &title Samsung FRP Tool [ADB Read Device Info] &cls &call :adb &pause >nul &goto main
if %errorlevel%==12 call "SikatPinoy Universal MTP Browser.cmd"
if %errorlevel%==13 start devmgmt.msc &goto main
if %errorlevel%==14 goto exit
goto main


:send_at
cls
call :checkport 
echo Detected: %port%
if exist tmp del tmp
set at=
set /p at="Enter AT Command Here [ex. AT+REACTIVE=1,0,0]: "
if not defined at echo No Entry &timeout 3 >nul &goto main
set "at=%at: =%"
echo Please wait sending AT cmd [%at%] ...
fart -q %function% "xxxxxxxxxx" "%at%"
echo Result:
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
python %function% | findstr /i Received >>tmp || python %function% | findstr /i Received >>tmp 
>nul 2>&1 fart -q tmp "%at%" " "
>nul 2>&1 fart -q tmp "OK" " "
>nul 2>&1 fart -q tmp "Received b" " "
>nul 2>&1 fart -q tmp "OK" " "
>nul 2>&1 fart -q tmp "'" " "
>nul 2>&1 fart -q tmp "\r" " "
>nul 2>&1 fart -q tmp "\n" " "
>nul 2>&1 fart -q tmp "b'" " "
>nul 2>&1 fart -q tmp ";" ", "
>nul 2>&1 fart -q tmp "+" " "
>nul 2>&1 fart -q tmp "   " " "
type tmp &del tmp
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo NOTE: Just try again if failed.
echo Finished
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main


:downloadmode
cls
call :checkport 
echo Detected: %port% 
if exist tmp del tmp
python.exe %function% >>"logs\%mytimestamp%.txt" 
echo Rebooting into Download Mode...
echo Finished
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main


:csc
cls
call :checkport 
echo Detected: %port% 
if exist tmp del tmp
set csc=
for /F "tokens=1" %%G IN ('dd /F:"csc.txt" "CSC List" "Select CSC"') DO set csc=%%G 
if not defined csc goto main
set csc=%csc: =%
echo Changing CSC to %csc%...
>nul 2>&1 fart -q %function% "xxx" "%csc%"
timeout 2 >nul
python.exe %function% | findstr /i "PROTECTED" >>"logs\%mytimestamp%.txt" 
if %errorlevel% NEQ 0 cls echo Changing CSC to %csc%...ok &pause >nul &goto main
echo Device is protected with token
echo Changing CSC to %csc%...failed 
echo Rebooting device
echo Finished
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main


:devinfo
cls
call :checkport 
echo Detected: %port% 
if exist tmp del tmp
echo.
echo Please wait reading device info...
python %function% | findstr /i "Received" >tmp || timeout 3 >nul && python %function% | findstr /i "Received" >tmp 
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

for /f "usebackq tokens=*" %%a in ("tmp") do (
    set "line=%%a"
  set "line=!line:\r\n=[]!"
    
    echo !line! | findstr "DEVCONINFO:" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%b in ("!line!") do (
            for /f %%c in ("%%b") do set "DEVCONINFOFULL=%%c"
      
      for /f "tokens=1 delims=[" %%b in ("!DEVCONINFOFULL!") do (
        for /f %%c in ("%%b") do set "DEVCONINFO=%%c"
        
        echo DEVICE INFO: !DEVCONINFO:~2! >>"logs\%mytimestamp%.txt" 
        echo                        --DEVICE GENERAL INFO-- &echo. &echo !DEVCONINFO:~2!
      )
        )
    )
)
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
for /f "usebackq tokens=*" %%a in ("tmp") do (
    set "line=%%a"
  set "line=!line:\r\n=[]!"
    
    echo !line! | findstr "SWVER:" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%b in ("!line!") do (
            for /f %%c in ("%%b") do set "SWVERFULL=%%c"
      
      for /f "tokens=1 delims=[" %%b in ("!SWVERFULL!") do (
        for /f %%c in ("%%b") do set "SWVER=%%c"
        
        echo SW VERSION:---!SWVER:~2! 
        echo SW VERSION:---!SWVER:~2! >>"logs\%mytimestamp%.txt" 
      )
        )
    )
)
for /f "usebackq tokens=*" %%a in ("tmp") do (
    set "line=%%a"
  set "line=!line:\r\n=[]!"
    
    echo !line! | findstr "IMEINUM:" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%b in ("!line!") do (
            for /f %%c in ("%%b") do set "IMEINUMFULL=%%c"
      
      for /f "tokens=1 delims=[" %%b in ("!IMEINUMFULL!") do (
        for /f %%c in ("%%b") do set "IMEINUM=%%c"
        
        echo IMEI:---------------!IMEINUM:~0!
        echo IMEI:---------------!IMEINUM:~0! >>"logs\%mytimestamp%.txt" 
      )
        )
    )
)
for /f "usebackq tokens=*" %%a in ("tmp") do (
    set "line=%%a"
  set "line=!line:\r\n=[]!"
    
    echo !line! | findstr "VERSNAME:" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%b in ("!line!") do (
            for /f %%c in ("%%b") do set "VERSNAMEFULL=%%c"
      
      for /f "tokens=1 delims=[" %%b in ("!VERSNAMEFULL!") do (
        for /f %%c in ("%%b") do set "VERSNAME=%%c"
        
        echo ANDROID VERSION:----!VERSNAME:~2!
        echo ANDROID VERSION:----!VERSNAME:~2! >>"logs\%mytimestamp%.txt" 
      )
        )
    )
)
for /f "usebackq tokens=*" %%a in ("tmp") do (
    set "line=%%a"
  set "line=!line:\r\n=[]!"
    
    echo !line! | findstr "SERIALNO:" >nul
    if not errorlevel 1 (
        for /f "tokens=2 delims=:" %%b in ("!line!") do (
            for /f %%c in ("%%b") do set "SERIALNOFULL=%%c"
      
      for /f "tokens=1 delims=[" %%b in ("!SERIALNOFULL!") do (
        for /f %%c in ("%%b") do set "SERIALNO=%%c"
        
        echo SERIAL NUMBER:------!SERIALNO:~2!
        echo SERIAL NUMBER:------!SERIALNO:~2! >>"logs\%mytimestamp%.txt" 
      )
        )
    )
)
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo Note: If reading info failed just try again.
if exist tmp del tmp
echo.
echo  
CmdMenuSel %scol% "                               MAIN                             "
if %errorlevel%==1 goto MAIN
goto main

:factory_reset
call :checkport
echo Detected: %port% 
echo Please wait reseting device...
python.exe %function% | findstr /i "Received" >>"logs\%mytimestamp%.txt"
echo Check if device reseted if not then try [hard reset].
fart -q %function% %port% DevicePort
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main


:enable_adb
call :checkport
echo Please wait enabling adb...
python.exe %function% | findstr /i "Received" >>"logs\%mytimestamp%.txt"
if %errorlevel% NEQ 0 cls &Please wait enabling adb...with error
fart -q %function% %port% DevicePort
cls
:adb
echo Please wait initializing...
adb kill-server >nul
adb start-server >nul
cls
set #=
:waiting
set /a #+=1
if %#%==0 cls &echo Waiting for devices /Í                               
if %#%==1 cls &echo Waiting for devices \ÍÍÍÍÍÍ 
if %#%==2 cls &echo Waiting for devices /ÍÍÍÍÍÍÍÍÍ
if %#%==3 cls &echo Waiting for devices \ÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==4 cls &echo Waiting for devices /ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==5 cls &echo Waiting for devices \ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==6 cls &echo Waiting for devices /ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==7 cls &echo Waiting for devices \ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==8 cls &echo Waiting for devices /ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %#%==9 set #=  
adb devices | findstr /i "unauthorized" && cls && echo Please Allow USB Debugging on your Device...%#% && timeout 3 >nul 
adb devices -l | findstr /i "model" && goto detected || cls && goto waiting
:detected
cls
echo. 
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ--DEVICE INFO--ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo.
for /F "tokens=*" %%G IN ('adb shell getprop ro.build.product') DO echo Build Product: ---------- %%G &echo Build Product: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop gsm.sim.state') DO echo SIM State [1,2] : ------- %%G &echo SIM State[1,2] %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell "service call iphonesubinfo 1 | toybox cut -d \"'\" -f2 | toybox grep -Eo '[0-9]' | toybox xargs | toybox sed 's/\ //g'"') DO echo IMEI number:  ----------- %%G &echo IMEI: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=3" %%G IN ('adb shell wm size') DO echo Screen Resolution:  ----- %%G &echo Screen Resolution: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.serialno')  DO echo Serial Number:  --------- %%G &echo Seial Number: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.hardware') DO echo Chip Type:  ------------- %%G &echo Chip Type: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.build.display.id') DO echo Build Number: ----------- %%G &echo Build Number: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.build.version.release') DO echo Android Version : ------- %%G &echo Android Version: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.build.version.security_patch') DO echo Security Patch: --------- %%G &echo Security Patch: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=1" %%G IN ('adb shell getprop gsm.version.baseband') DO echo Baseband Version: ------- %%G &echo Baseband Version: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop sys.usb.config') DO echo USB Configuration: ------ %%G &echo USB Configuration: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop gsm.sim.operator.alpha') DO echo SIM Operator: ---------- %%G &echo Sim operator: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=3" %%G IN ('adb shell cat /proc/version') DO echo Kernel Version: --------- %%G &echo Kernel Version: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.boot.hardware.ddr') DO echo RAM Information: ------ %%G &echo Ram Information: %%G >>"logs\%mytimestamp%.txt"
for /F "tokens=*" %%G IN ('adb shell getprop ro.boot.hardware.emmc') DO echo Rom Information: ------ %%G &echo Rom information: %%G >>"logs\%mytimestamp%.txt"
echo.
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
if %function%==adb echo Reading Device info done! &exit /b
if %function%==frp2 goto frp2
if %n%==1 echo Enabling Samsung ADB done^! &pause >nul &goto main
echo Removing frp...
adb shell settings put global setup_wizard_has_run 1 >nul 2>&1
adb shell settings put secure user_setup_complete 1 >nul 2>&1
adb shell content insert --uri content://settings/secure --bind >nul 2>&1
adb shell content insert --uri content://settings/secure --bind name:s:user_setup_complete --bind value:s:1 >nul 2>&1
adb shell am start -n com.google.android.gsf.login/ >nul 2>&1
adb shell am start -n com.google.android.gsf.login.LoginActivity >nul 2>&1
adb shell am start -c android.intent.category.HOME -a android.intent.action.MAIN  >nul 2>&1
adb shell input keyevent 3 >nul 2>&1 
taskkill /f /im adb.exe >nul 2>&1 
if %errorlevel%==0 echo Removing frp ...done 
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main 

:checkport
set #=0
7z e pcode.7z %function% -passcode >nul 2>&1
:qcheckport
set /a #+=1
cls
echo Waiting for samsung device...%#%  &timeout 1 >nul
if %#%==120 goto nodevice
reg query HKLM\hardware\devicemap\SERIALCOMM | findstr /I "ssudmdm0000" >port || goto qcheckport
for /f "tokens=3" %%G IN (port) DO set "port=%%G" &del /f port
fart -q %function% DevicePort %port% 
if %function%==reset.py exit /b
if %function%==info.py exit /b
if %function%==dm.py exit /b
if %function%==at_sender.py exit /b 
cls
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo.
echo Detected: %port% 
echo                     -##-INSTRUCTION-##-
echo.
echo    On your Phone Screen open Emergency Call and Dial *#0*# 
echo.
echo               ---Press Enter to Continue---
echo.
echo ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
echo  
pause >nul
cls
exit /b

:frp2
echo Please wait Removing frp...
adb push frp.bin /data/local/tmp/temp >nul 2>&1
echo Setting up permissions...
adb shell chmod 777 /data/local/tmp/temp >nul 2>&1
echo Executiong the binary file... >nul 2>&1
adb shell /data/local/tmp/temp | findstr /i ":"
echo Cleaning temp file...
adb shell rm /data/local/tmp/temp >nul 2>&1
echo Rebooting device...
echo Removing frp done^!
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main

:nodevice
echo No device
echo   
timeout 3 >nul
:exit
cls
echo.
echo Thank you for using Samsung FRP Tool by drox-Ph-Ceb
echo Gcash - cash 09451035299
taskkill /f /im adb.exe >nul 2>&1
timeout 5 >nul
exit

:checkdm
set #=30
:odin
cls
set /a #-=1
if %#%==0 goto nodevice
echo Please wait checking for device...%#%
odin -l | findstr /i com && echo Rebooting device to normal mode... && odin --reboot >>"logs\%mytimestamp%.txt" || timeout 1 >nul && goto odin
echo Finished
echo  
CmdMenuSel %scol% "                               MAIN                             "
goto main
