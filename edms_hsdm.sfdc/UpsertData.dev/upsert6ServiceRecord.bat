@echo off
REM cls
SETLOCAL

REM -- preparing based variables --
set env=dev
set srcpath=%cd%
set label=Service Record
set svcname=csvUpsertServiceRecord
set logfile=ServiceRecord.log
set srcfile=ServiceRecord.csv
set csv_error=upsertServiceRecord_err.csv
set csv_ok=upsertServiceRecord_ok.csv

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