@echo off

SETLOCAL
REM -- define log type --
set _log=!Logs
set logtype=dev

:: Write CSV files
call WriteLog.bat Generating CSV files based on EDMS data . . .
pushd DTS.dev
echo Generating Dealer CSV . . .
echo.
call "%~dp0WriteLog.bat" Writing Dealer CSV . . .
call DealerDTS.exe >> ..\%_log%.%logtype%\DTS.log

echo Generating Model CSV . . .
echo.
call "%~dp0WriteLog.bat" Writing Product CSV . . .
call ProductDTS.exe >> ..\%_log%.%logtype%\DTS.log

echo Generating Account CSV . . .
echo.
call "%~dp0WriteLog.bat" Writing Account CSV . . .
call AccountDTS.exe >> ..\%_log%.%logtype%\DTS.log

echo Generating Vehicle CSV . . .
echo.
call "%~dp0WriteLog.bat" Writing Vehicle CSV . . .
call VehicleDTS.exe >> ..\%_log%.%logtype%\DTS.log

echo Generating Sales Order CSV . . .
echo.
call "%~dp0WriteLog.bat" Writing Sales Order CSV . . .
call SalesOrderDTS.exe >> ..\%_log%.%logtype%\DTS.log

REM d "%~dp0"
popd
call WriteLog.bat All CSV generated!

:: update CSV into Salesforce
call WriteLog.bat Begin updating data into Salesforce . . .
pushd UpsertData.dev
call upsert1Dealer.bat
call upsert2Product.bat
call upsert3Account.bat
call upsert4Vehicle.bat
call upsert5SalesOrder.bat
REM call upsert6ServiceRecord.bat
REM cd "%~dp0"
popd
call WriteLog.bat Data upload to Salesforce completed!

REM work around to remove status folder created by unknown!
rmdir status >nul

ENDLOCAL
