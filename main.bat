@echo off
setlocal EnableDelayedExpansion

set wg_name=wg_name
set domain=mydomain

@REM call:getDomainIp
@REM echo %local_ip%
@REM set "old_ip=%ip%"

::定义检测方法
:check
call:getWgIp
call:getDomainIp
echo %clean_local_ip%
echo %clean_wg_ip%
if "%clean_local_ip%" == "%clean_wg_ip%" (
    echo The values are equal.
) else (
    echo The values are not equal.
)

choice /t 5 /d y /n > null
goto:check

::定义获取IP的方法
:getDomainIp
for /f "tokens=2 delims=:" %%a in ('nslookup %domain% ^| findstr "Address:"') do (
    set "local_ip=%%a"
)
:: 去除IP地址中的空格（如果有的话）
set "clean_local_ip=!local_ip: =!"
goto :eof

::定义获取wgIP的方法
:getWgIp
for /f "tokens=2 delims=:" %%w in ('wg show %wg_name% ^| findstr "endpoint:"') do (
    set "wg_ip=%%w"
)
:: 去除IP地址中的空格（如果有的话）
set "clean_wg_ip=!wg_ip: =!"
goto :eof