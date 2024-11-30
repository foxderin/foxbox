@echo off
:: PowerShell 执行策略选择脚本

echo 请选择 PowerShell 执行策略等级:
echo 1. Restricted (默认，不允许执行脚本)
echo 2. AllSigned (仅允许签名的脚本)
echo 3. RemoteSigned (允许本地脚本和受信任的远程脚本)
echo 4. Unrestricted (允许所有脚本)
echo 5. Bypass (绕过所有脚本执行策略)
echo 6. Undefined (恢复默认设置)

set /p choice=请输入对应的数字并按回车:

:: 根据用户输入选择执行策略
if "%choice%"=="1" (
    powershell -Command "Set-ExecutionPolicy Restricted -Scope CurrentUser -Force"
    echo 执行策略已设置为 Restricted (不允许执行任何脚本).
) else if "%choice%"=="2" (
    powershell -Command "Set-ExecutionPolicy AllSigned -Scope CurrentUser -Force"
    echo 执行策略已设置为 AllSigned (仅允许签名脚本).
) else if "%choice%"=="3" (
    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
    echo 执行策略已设置为 RemoteSigned (允许本地脚本和受信任的远程脚本).
) else if "%choice%"=="4" (
    powershell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"
    echo 执行策略已设置为 Unrestricted (允许所有脚本).
) else if "%choice%"=="5" (
    powershell -Command "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"
    echo 执行策略已设置为 Bypass (绕过所有执行策略).
) else if "%choice%"=="6" (
    powershell -Command "Set-ExecutionPolicy Undefined -Scope CurrentUser -Force"
    echo 执行策略已设置为 Undefined (恢复默认设置).
) else (
    echo 无效的选择，退出脚本.
)

pause
