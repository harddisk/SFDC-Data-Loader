@Echo off
:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
	IF "%%~L"=="" goto s_done

		Set _yyyy=%%L
		Set _mm=00%%J
		Set _dd=00%%G
		Set _hour=00%%H
		Set _minute=00%%I
		Set _second=00%%K
)
:s_done

:: Pad digits with leading zeros
Set _mm=%_mm:~-2%
Set _dd=%_dd:~-2%
Set _hour=%_hour:~-2%
Set _minute=%_minute:~-2%
Set _second=%_second:~-2%

:: Display the date/time in ISO 8601 format:
Set datetime=%_yyyy%%_mm%%_dd%_%_hour%%_minute%%_second%
REM Echo %datetime%

GOTO:EOF

:s_error
Echo Error acquiring date in %0
Echo.
Echo Unable to proceed.
pause