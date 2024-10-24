@echo off
setlocal EnableDelayedExpansion

set default_wg_name=wg_name
set default_domain=mydomain
set default_file_path=%USERPROFILE%\wireguard-plugin\output.txt

set /p wg_name=please enter wg_tunnel:default:(%default_wg_name%)
set /p domain=please enter domain:default:(%default_domain%)
set /p file_path=please enter file_path:default:(%default_file_path%)

if "%wg_name%" == "" (
    set wg_name=%default_wg_name%
)
if "%domain%" == "" (
    set domain=%default_domain%
)
if "%file_path%" == "" (
    set file_path=%default_file_path%
)

:check
::获取domain IP
for /F "tokens=2 delims=[]" %%a in ('ping -n 1 %domain% ^| findstr "["') do (
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
echo %date% %time% domain_ip: %clean_domain_ip% wg_ip: %clean_wg_ip% >> "%file_path%"
if "%clean_domain_ip%" == "%clean_wg_ip%" (
    echo The values are equal >> "%file_path%"
) else (
    echo The values are not equal >> "%file_path%"
    net stop "WireGuard Tunnel: %wg_name%" >> "%file_path%"
    net start "WireGuard Tunnel: %wg_name%" >> "%file_path%"
)
::睡眠五秒
timeout /t 300 >nul
goto:check