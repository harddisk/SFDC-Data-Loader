@echo off
cls
SETLOCAL

REM -- preparing based variables --
set env=prod
set srcpath=%cd%
set label=Sales Order
set svcname=csvUpsertSalesOrder
set logfile=SalesOrder.log
set srcfile=SalesOrder.csv
set csv_error=upsertSalesOrder_err.csv
set csv_ok=upsertSalesOrder_ok.csv

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