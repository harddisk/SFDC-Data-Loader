@echo off
REM cls
SETLOCAL

REM -- preparing based variables --
set env=dev
set srcpath=%cd%
set label=Account
set svcname=csvUpsertAccount
set logfile=Account.log
set srcfile=Account.csv
set csv_error=upsertAccount_err.csv
set csv_ok=upsertAccount_ok.csv

call ..\Copyright.bat

REM -- tricks to set root path --
pushd ..
set rootpath=%cd%
popd

REM -- compound variables --
call ..\GetDT.bat
set title=Running Job -- %label%.%env%
set source=%rootpath%\CSV\%srcfile%
set target=%rootpath%\%_log%.%env%\CSV\%datetime%-%srcfile%
set log=%rootpath%\%_log%.%env%\%datetime%-%logfile%
set logok=%rootpath%\%_log%.%env%\CSV\%datetime%-%csv_ok%
set loger=%rootpath%\%_log%.%env%\CSV\%datetime%-%csv_error%

call runUpsert.bat

REM -- restore cmd title --
title %ComSpec%

ENDLOCAL