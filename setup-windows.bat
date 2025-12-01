@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==========================================
echo   TrendRadar MCP One-click Setup (Windows)
echo ==========================================
echo.

REM Use script directory instead of current working directory
set "PROJECT_ROOT=%~dp0"
REM Remove trailing backslash
if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

echo 📍 Project directory: %PROJECT_ROOT%
echo.

REM Switch to project directory
cd /d "%PROJECT_ROOT%"
if %errorlevel% neq 0 (
    echo ❌ Cannot access project directory
    pause
    exit /b 1
)

REM Verify project structure
echo [0/4] 🔍 Verifying project structure...
if not exist "pyproject.toml" (
    echo ❌ pyproject.toml not found in: %PROJECT_ROOT%
    echo.
    echo Please check:
    echo   1. Is setup-windows.bat in the project root?
    echo   2. Are project files complete?
    echo.
    echo Current directory contents:
    dir /b
    echo.
    pause
    exit /b 1
)
echo ✅ pyproject.toml found
echo.

REM Check Python
echo [1/4] 🐍 Checking Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not detected, please install Python 3.10+
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('python --version') do echo ✅ %%i
echo.

REM Check uv
echo [2/4] 🔧 Checking uv...
where uv >nul 2>&1
if %errorlevel% neq 0 (
    echo uv is not installed, installing automatically...
    echo.
    
    echo Trying method 1: PowerShell install...
    powershell -ExecutionPolicy Bypass -Command "try { irm https://astral.sh/uv/install.ps1 | iex; exit 0 } catch { Write-Host 'PowerShell install failed'; exit 1 }"
    
    if %errorlevel% neq 0 (
        echo.
        echo Method 1 failed, trying method 2: pip install...
        python -m pip install --upgrade uv
        
        if %errorlevel% neq 0 (
            echo.
            echo ❌ Automatic installation failed
            echo.
            echo Please install uv manually, options:
            echo.
            echo   Method 1 - pip:
            echo     python -m pip install uv
            echo.
            echo   Method 2 - pipx:
            echo     pip install pipx
            echo     pipx install uv
            echo.
            echo   Method 3 - manual:
            echo     Visit: https://docs.astral.sh/uv/getting-started/installation/
            echo.
            pause
            exit /b 1
        )
    )
    
    echo.
    echo ✅ uv installation completed!
    echo.
    echo ⚠️  IMPORTANT: Please follow these steps:
    echo   1. Close this window
    echo   2. Re-open Command Prompt (or PowerShell)
    echo   3. Go back to project directory: %PROJECT_ROOT%
    echo   4. Run this script again: setup-windows.bat
    echo.
    pause
    exit /b 0
) else (
    for /f "tokens=*" %%i in ('uv --version') do echo ✅ %%i
)
echo.

echo [3/4] 📦 Installing project dependencies...
echo Working directory: %PROJECT_ROOT%
echo.

REM Ensure we are in the project directory
cd /d "%PROJECT_ROOT%"
uv sync
if %errorlevel% neq 0 (
    echo.
    echo ❌ Dependency installation failed
    echo.
    echo Possible reasons:
    echo   1. Network issues
    echo   2. Incompatible Python version (requires ^>= 3.10)
    echo   3. Invalid pyproject.toml
    echo.
    echo Troubleshooting:
    echo   - Check network connectivity
    echo   - Verify Python version: python --version
    echo   - Try verbose output: uv sync --verbose
    echo.
    echo Project directory: %PROJECT_ROOT%
    echo.
    pause
    exit /b 1
)
echo.
echo ✅ Dependencies installed successfully
echo.

echo [4/4] ⚙️  Checking config file...
if not exist "config\config.yaml" (
    echo ⚠️  Config file not found: config\config.yaml
    if exist "config\config.example.yaml" (
        echo.
        echo Create config file:
        echo   1. Copy: copy config\config.example.yaml config\config.yaml
        echo   2. Edit: notepad config\config.yaml
        echo   3. Fill in API keys
    )
    echo.
) else (
    echo ✅ config\config.yaml exists
)
echo.

REM Get uv path
for /f "tokens=*" %%i in ('where uv 2^>nul') do set "UV_PATH=%%i"
if not defined UV_PATH (
    set "UV_PATH=uv"
)

echo.
echo ==========================================
echo            Setup Completed!
echo ==========================================
echo.
echo 📋 MCP server configuration (for Claude Desktop, etc.):
echo.
echo   Command: %UV_PATH%
echo   Working directory: %PROJECT_ROOT%
echo.
echo   Arguments (one per line):
echo     --directory
echo     %PROJECT_ROOT%
echo     run
echo     python
echo     -m
echo     mcp_server.server
echo.
echo 📖 Detailed guide: README-Cherry-Studio.md
echo.
echo.
pause