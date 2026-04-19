@echo off
echo ==========================================
echo Sentinel Mobile - GitHub Setup Script
echo ==========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed.
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo Git found. Good!
echo.

REM Get GitHub username
set /p USERNAME="Enter your GitHub username: "

if "%USERNAME%"=="" (
    echo ERROR: Username cannot be empty.
    pause
    exit /b 1
)

set REPO_NAME=sentinel-mobile

echo.
echo Setting up GitHub repository...
echo.

REM Initialize git if not already done
if not exist .git (
    git init
    echo Initialized Git repository.
) else (
    echo Git repository already initialized.
)

REM Add all files
git add .

REM Commit
git commit -m "Initial commit - Sentinel Mobile" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Files committed.
) else (
    echo No changes to commit or already committed.
)

REM Set main branch
git branch -M main 2>nul

echo.
echo ==========================================
echo INSTRUCTIONS:
echo ==========================================
echo.
echo 1. First, create a repository on GitHub:
echo    - Go to: https://github.com/new
echo    - Repository name: %REPO_NAME%
echo    - Click: Create repository
echo.
echo 2. Then run these commands:
echo.
echo    git remote add origin https://github.com/%USERNAME%/%REPO_NAME%.git
echo    git push -u origin main
echo.
echo 3. After pushing, GitHub will automatically
echo    build your APK! Check the Actions tab.
echo.
echo ==========================================
echo.

REM Check if remote already exists
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Creating remote...
    git remote add origin https://github.com/%USERNAME%/%REPO_NAME%.git 2>nul
    echo.
    echo Ready to push! Run:
    echo    git push -u origin main
    echo.
) else (
    echo Remote already configured.
    echo.
    echo To push changes, run:
    echo    git push origin main
    echo.
)

pause
