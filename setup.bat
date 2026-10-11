@echo off
setlocal

REM ===========================================================================
REM  Library-RDCToolsLib - one-time setup for STANDALONE development
REM
REM  RDCToolsLib depends on vwin32fh (ten packages Use vWin32fh.pkg). It is not
REM  nested; it is a separate sibling library. This script is only for working
REM  on RDCToolsLib on its own - it clones vwin32fh as a sibling of this folder,
REM  which is where RDCToolsLibDev25.0.sws / RDCToolsLibDev26.0.sws expect it
REM  (..\vwin32fh).
REM
REM  DFUnit, the unit-test library, is cloned beside it (..\DFUnit). The
REM  RDCToolsLibDev workspaces take it from there for the test program
REM  AppSrc\UnitTests.src.
REM
REM  When RDCToolsLib is consumed as a library inside another workspace, that
REM  workspace already provides vwin32fh and this script is not needed - if run
REM  there, it finds vwin32fh present and does nothing.
REM
REM  Open RDCToolsLibDev25.0.sws (or 26.0) to test-compile the library via its
REM  Dummy.src canary. The RDCToolsLibLibrary*.sws files are the consumer-facing
REM  entry points and declare no libraries and no projects on purpose.
REM ===========================================================================

cd /d "%~dp0"

echo.
echo === Library-RDCToolsLib standalone setup ===
echo Folder: %CD%
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git was not found on your PATH.
    echo         Install Git ^(or the GitHub Desktop app^), reopen the
    echo         command prompt, and run setup.bat again.
    echo.
    pause
    exit /b 1
)

if exist "..\vwin32fh\.git" (
    echo [vwin32fh] already present - pulling latest...
    git -C "..\vwin32fh" pull --ff-only
) else (
    echo [vwin32fh] cloning as a sibling...
    git clone https://github.com/NilsSve/Library-vwin32fh.git "..\vwin32fh"
    if errorlevel 1 (
        echo.
        echo [ERROR] Could not clone Library-vwin32fh.
        echo         Check your connection and that you can reach:
        echo           https://github.com/NilsSve/Library-vwin32fh.git
        echo.
        pause
        exit /b 1
    )
)

if exist "..\DFUnit\.git" (
    echo [DFUnit] already present - pulling latest...
    git -C "..\DFUnit" pull --ff-only
) else (
    echo [DFUnit] cloning as a sibling...
    git clone https://github.com/NilsSve/Library-DFUnit.git "..\DFUnit"
    if errorlevel 1 (
        echo.
        echo [ERROR] Could not clone Library-DFUnit.
        echo         Check your connection and that you can reach:
        echo           https://github.com/NilsSve/Library-DFUnit.git
        echo.
        pause
        exit /b 1
    )
)

echo.
echo === Setup complete ===
echo.
echo vwin32fh and DFUnit are now siblings of this folder. Open
echo RDCToolsLibDev25.0.sws (or 26.0) in the Studio and build Dummy.src to
echo verify the library, or UnitTests.src to run its unit tests.
echo.
pause
exit /b 0
