@echo off
setlocal EnableDelayedExpansion

set wg_name=wg_name
set domain=mydomain
set file_path=%USERPROFILE%\wireguard-plugin\output.txt

for /F "tokens=2 delims=[]" %%a in ('ping -n 1 %domain% ^| findstr "["') do (echo IP=%%a)

:check
::获取domain IP
for /f "tokens=2 delims=:" %%a in ('nslookup %domain% ^| findstr "Address:"') do (
    set "domain_ip=%%a"
)
:: 去除IP地址中的空格（如果有的话）
set "clean_domain_ip=!domain_ip: =!"

::定义获取wg IP
for /f "tokens=2 delims=:" %%w in ('wg show %wg_name% ^| findstr "endpoint:"') do (
    set "wg_ip=%%w"
)
:: 去除IP地址中的空格（如果有的话）
set "clean_wg_ip=!wg_ip: =!"

::检测
echo domain_ip: %clean_domain_ip% >> "%file_path%"
echo wg_ip: %clean_wg_ip% >> "%file_path%"
if "%clean_domain_ip%" == "%clean_wg_ip%" (
    echo The values are equal. >> "%file_path%"
) else (
    echo The values are not equal. >> "%file_path%"
)
::睡眠五秒
timeout /t 5 >nul
goto:check