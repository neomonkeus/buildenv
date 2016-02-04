@echo off

rem *******************
rem ** Detect Values **
rem *******************

rem system
if "%ProgramFiles(x86)%" == "" set _arch_type=32
if not "%ProgramFiles(x86)%" == "" set _arch_type=64
set ProgramFiles32=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set ProgramFiles32=%ProgramFiles(x86)%

set _work_folder=%HOMEDRIVE%%HOMEPATH%

rem compilers
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v 9.0 2^> nul') do set _msvc2008=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC" set _msvc2008=%ProgramFiles32%\Microsoft Visual Studio 9.0\VC

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v 9.0 2^> nul') do set _msvc2008=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 9.0\VC" set _msvc2008=%ProgramFiles32%\Microsoft Visual Studio 9.0\VC

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v 10.0 2^> nul') do set _msvc2010=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 10.0\VC" set _msvc2010=%ProgramFiles32%\Microsoft Visual Studio 10.0\VC

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v 10.0 2^> nul') do set _msvc2010=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 10.0\VC" set _msvc2010=%ProgramFiles32%\Microsoft Visual Studio 10.0\VC

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" /v 11.0 2^> nul') do set _msvc2012=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 11.0\VC" set _msvc2012=%ProgramFiles32%\Microsoft Visual Studio 11.0\VC

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" /v 11.0 2^> nul') do set _msvc2012=%%B
if exist "%ProgramFiles32%\Microsoft Visual Studio 11.0\VC" set _msvc2012=%ProgramFiles32%\Microsoft Visual Studio 11.0\VC


rem MS_SDKs
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v6.0" /v InstallationFolder 2^> nul') do set _ms_sdk_six=%%B
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v6.0A" /v InstallationFolder 2^> nul') do set _ms_sdk_six=%%B
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.0" /v InstallationFolder 2^> nul') do set _ms_sdk_seven=%%B
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Microsoft SDKs\Windows\v7.1" /v InstallationFolder 2^> nul') do set _ms_sdk_seven_one=%%B

rem langs
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\2.6\InstallPath" /ve 2^> nul') do set _python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\2.7\InstallPath" /ve 2^> nul') do set _python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\3.2\InstallPath" /ve 2^> nul') do set _python_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Python\PythonCore\3.3\InstallPath" /ve 2^> nul') do set _python_path=%%B

rem programs
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\BlenderFoundation" /v Install_Dir 2^> nul') do set _blender=%%B

rem utilities
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1" /v InstallLocation 2^> nul') do set _git_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1" /v InstallLocation 2^> nul') do set _git_path=%%B

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Kitware\CMake 2.8.9" /ve 2^> nul') do set _cmake=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\Kitware\CMake 2.8.9" /ve 2^> nul') do set _cmake=%%B

FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\NSIS" /ve 2^> nul') do set _nsis_path=%%B
FOR /F "tokens=2*" %%A in ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\NSIS" /ve 2^> nul') do set _nsis_path=%%B

FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\Wow6432Node\7-Zip" /v Path 2^> nul') do set _seven_zip=%%B
FOR /F "tokens=2*" %%A IN ('reg.exe QUERY "HKLM\SOFTWARE\7-Zip" /v Path 2^> nul') do set _seven_zip=%%B

rem Libraries


rem *************
rem ** Runtime **
rem *************

if "%1" == "" (
echo.Path to ini file/folder not set;
echo.Opening README.rst
echo.
echo.Please refer to this document for correct syntax and .ini file contents
echo.before trying to execute the create-shortcuts.bat again.

start notepad.exe README.rst
goto displayparams
)

:helpcheck
if "%1" == "-help" goto displayparams
if "%1" == "--help" goto displayparams
if "%1" == "-h" goto displayparams
if "%1" == "/h" goto displayparams
if "%1" == "/?" goto displayparams
goto checkparams

:displayparams
echo.Usage: buildenv.bat ^<settings.ini^>
echo.
echo.Initializes environment for software development.
echo.
echo.Auto-detected Locations:

rem Misc
echo.  start=FOLDER            [default: %_work_folder%]
echo.  arch=BITS               [default: %_arch_type%]
echo.  ci_output=FILE		   [default: %_ci_prop_file%]

rem Lang
echo.Languages:
echo.  python=FOLDER           [default: %_python_path%]

rem Progs
echo.Programs:
echo.  blender=FOLDER          [default: %_blender%]

rem Utilities
echo.Utilities:
echo.  git=FOLDER              [default: %_git_path%]
echo.  nsis=FOLDER             [default: %_nsis_path%]
echo.  cmake=FOLDER            [default: %_cmake%]
echo.  qmake=FOLDER            [default: %_qmake%]
echo.  seven_zip=FOLDER        [default: %_seven_zip%]
echo.  pydev_debug=FOLDER	   [default: %_pydev_debug%]

rem compilers
echo.Compilers:
echo.  compiler=COMPILER       [default: %_compiler_type%]
echo.  msvc2008=FOLDER         [default: %_msvc2008_32%]
echo.  msvc2010=FOLDER         [default: %_msvc2010_32%]
echo.  msvc2012=FOLDER         [default: %_msvc2012_32%]
echo.  msvc2008_64=FOLDER      [default: %_msvc2008_64%]
echo.  msvc2010_64=FOLDER      [default: %_msvc2010_64%]
echo.  msvc2012_64=FOLDER      [default: %_msvc2012_64%]

rem ms_sdk
echo.MS SDKs
echo.  ms_sdk_6.0=FOLDER	   [default: %_ms_sdk_six%]
echo.  ms_sdk_7.0=FOLDER	   [default: %_ms_sdk_seven%]
echo.  ms_sdk_7.1=FOLDER	   [default: %_ms_sdk_seven_one%]

rem libs
echo.Libraries:
echo.  swig=FOLDER             [default: %_swig%]

echo.  boostinc=FOLDER         [default: %_boostinc%]
echo.  boostlib=FOLDER         [default: %_boostlib%]

echo.  qt=FOLDER               [default: %_qt_path%]

rem Likely, the script was run from Windows explorer...
pause
goto end

:checkparams
for /F "tokens=* delims=" %%a in ('type %1') do call :parseparam "%%a"
goto settings

:parseparam
rem Get switch and value, and remove surrounding quotes.
set _line="%~1"
for /F "tokens=1,2 delims==" %%a in ('echo.%_line%') do set SWITCH=%%a^"&set VALUE=^"%%b
set _line=
set SWITCH=%SWITCH:"=%
set VALUE=%VALUE:"=%
echo.Parsing %SWITCH%=%VALUE%

rem Misc
if "%SWITCH%" == "start" set _work_folder=%VALUE%
if "%SWITCH%" == "arch" set _arch_type=%VALUE%
if "%SWITCH%" == "ci_output" set _ci_prop_file=%VALUE%

rem Lang
if "%SWITCH%" == "python" set _python_path=%VALUE%

rem Progs
if "%SWITCH%" == "blender" set _blender=%VALUE%
if "%SWITCH%" == "msvc2008" set _msvc2008=%VALUE%
if "%SWITCH%" == "msvc2010" set _msvc2010=%VALUE%
if "%SWITCH%" == "msvc2012" set _msvc2012=%VALUE%

rem Utilities
if "%SWITCH%" == "git" set _git_path=%VALUE%
if "%SWITCH%" == "nsis" set _nsis_path=%VALUE%
if "%SWITCH%" == "cmake" set _cmake=%VALUE%
if "%SWITCH%" == "qmake" set _qmake=%VALUE%
if "%SWITCH%" == "seven_zip" set _seven_zip=%VALUE%
if "%SWITCH%" == "pydev_debug" set _pydev_debug=%VALUE%

rem compilers
if "%SWITCH%" == "msvc2008" set _compiler_type=msvc2008
if "%SWITCH%" == "msvc2010" set _compiler_type=msvc2010
if "%SWITCH%" == "msvc2012" set _compiler_type=msvc2012

if "%SWITCH%" == "msvc2008_64" set _compiler_type=msvc2008
if "%SWITCH%" == "msvc2010_64" set _compiler_type=msvc2010
if "%SWITCH%" == "msvc2012_64" set _compiler_type=msvc2012

if "%SWITCH%" == "compiler" set _compiler_type=%VALUE%

rem libs
if "%SWITCH%" == "qt" set _qt_path=%VALUE%
if "%SWITCH%" == "swig" set _swig=%VALUE%
if "%SWITCH%" == "boostinc" set _boostinc=%VALUE%
if "%SWITCH%" == "boostlib" set _boostlib=%VALUE%
goto eof


rem ********************
rem *** Architecture ***
rem ********************


:settings
echo.
echo.Script Running:
echo.
echo.Setting Program Files

rem Implementation note: do not embed %ProgramFiles32% into brackets
rem because the brackets will be misinterpreted by the command processor
rem http://marsbox.com/blog/howtos/batch-file-programfiles-x86-parenthesis-anomaly/

echo.Program Folder:
echo.  32-bit: %ProgramFiles32%
echo.  native: %ProgramFiles%

echo.
echo.Setting Architecture

echo.  Architecture: %_arch_type% bit

echo.
echo.CI Output File:
if exist "%_ci_prop_file%" goto postCiProp
goto endsettings

:postCiProp
echo.  Using: %_ci_prop_file%
echo.  Clearing file.
echo. >"%_ci_prop_file%"


:endsettings


rem *****************
rem *** Languages ***
rem *****************


:python
echo.
echo.Setting Python Environment
if exist "%_python_path%\python.exe" goto pythonfound
echo.Python not found
goto endpython

:pythonfound
set _path=%_python_path%;%_python_path%\Scripts;%_path%
rem PYTHONPATH has another purpose, so use PYTHONFOLDER
rem http://docs.python.org/using/cmdline.html#envvar-PYTHONPATH
set PYTHONFOLDER=%_python_path%
%_python_path%\python.exe -c "import sys; print(""  ""+sys.version)"

if exist "%_ci_prop_file%" goto postCiPython
goto endpython

:postCiPython
echo.PYTHONFOLDER=%PYTHONFOLDER% >>"%_ci_prop_file%"


:endpython


rem ****************
rem *** Programs ***
rem ****************


:blender
echo.
echo.Setting Blender Environment

if exist "%_blender%\blender.exe" set BLENDERHOME=%_blender%
if "%BLENDERHOME%" == "" (
  echo.  Blender not found
  goto endblender
)
set _path=%_blender%;%_path%
if exist "%_ci_prop_file%" goto postCiBlender
goto noCiBlender

:postCiBlender
echo.BLENDERHOME=%BLENDERHOME% >>"%_ci_prop_file%"

:noCiBlender
echo.  Blender home: %BLENDERHOME%

for %%A in (2.70,2.71,2.72,2.73,2.74,2.75,2.76,2.77,2.78,2.79,2.80) do (
  if exist "%BLENDERHOME%\%%A" set BLENDERVERSION=%%A
)
if "%BLENDERVERSION%" == "" (
  echo.  Blender version not found
  goto endblender
)
if exist "%_ci_prop_file%" goto ciblenderversion
goto nociblenderversion

:ciblenderversion
echo.BLENDERVERSION=%BLENDERVERSION% >>"%_ci_prop_file%"

:nociblenderversion

echo.  Blender version: %BLENDERVERSION%

if exist "%BLENDERHOME%\%BLENDERVERSION%\scripts\addons" set BLENDERADDONS=%BLENDERHOME%\%BLENDERVERSION%\scripts\addons
if "%BLENDERADDONS%" == "" (
  echo.  Blender addons not found
  goto endblender
)
if exist "%APPDATA%\Blender Foundation\Blender\%BLENDERVERSION%\scripts\addons" goto APPDATABlenderAddon
echo.WARNING!!! The APPDATA folder used by blender has not been generated
echo.Use the plugin manager in blender to create the folder before 
echo.using the install bat file.

goto noAPPDATABlenderAddon

:APPDATABlenderAddon
set APPDATABLENDERADDONS=%APPDATA%\Blender Foundation\Blender\%BLENDERVERSION%\scripts\addons

:noAPPDATABlenderAddon
if exist "%_ci_prop_file%" goto postCiBlenderAddon
goto noCiBlenderAddon

:postCiBlenderAddon
echo.BLENDERADDONS=%BLENDERADDONS% >>"%_ci_prop_file%" 
echo.APPDATABLENDERADDONS=%APPDATABLENDERADDONS% >>"%_ci_prop_file%" 

:noCiBlenderAddon

echo.
echo.  Global Blender addons: 
echo.
echo.  %BLENDERADDONS%
echo.  Local Blender addons:
echo.
echo.  %APPDATABLENDERADDONS%

:endblender


rem *****************
rem *** Utilities ***
rem *****************


:git
echo.
echo.Setting Git Environment

if exist %_git_path%\git.exe goto gitset
goto gitsearch

:gitset 
  set GITHOME=%_git_path%
  goto gitfound

:gitsearch
if exist "%ProgramFiles32%\Git\bin\git.exe" (
set GITHOME="%ProgramFiles32%\Git\bin"
goto gitfound
)
if exist "%ProgramFiles%\Git\bin\git.exe" (
set GITHOME="%ProgramFiles%\Git\bin"
goto gitfound
)
if exist "%LOCALAPPDATA%\GitHub" goto appdatagit

:appdatagit
for /f "tokens=*" %%A in ('dir %LOCALAPPDATA%\GitHub\PortableGit_* /b') do set GITHOME=%LOCALAPPDATA%\GitHub\%%A

if exist %_git_path%bin\git.exe goto inigit
goto noinigit

:inigit 
set GITHOME=%_git_path%
if "%GITHOME:~-1%"=="\" SET GITHOME=%GITHOME:~0,-1%
goto gitfound

:noinigit

if "%GITHOME%" == "" (
  echo.  Git not found
  goto endgit
)

:gitfound

echo.  Git home: %GITHOME%
set _path=%GITHOME%;%_path%
set git=%_git_path%bin\git.exe

if exist "%_ci_prop_file%" goto cigit
goto endgit

:cigit
echo.GITHOME=%GITHOME% >>"%_ci_prop_file%" 

:endgit

:nsis
echo.
echo.Setting NSIS Environment
if exist "%ProgramFiles32%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles32%\NSIS
if exist "%ProgramFiles%\NSIS\makensis.exe" set NSISHOME=%ProgramFiles%\NSIS
if exist "%_nsis_path%\makensis.exe" set NSISHOME=%_nsis_path%
if "%NSISHOME%" == "" (
  echo.  NSIS not found
  goto endnsis
)
echo.  NSIS home: %NSISHOME%
set _path=%NSISHOME%;%_path%

if exist "%_ci_prop_file%" goto cinsis
goto endnsis

:cinsis
echo.NSISHOME=%NSISHOME% >>"%_ci_prop_file%" 

:endnsis

:cmake
echo.
echo.Setting CMake Environment
if exist "%ProgramFiles32%\CMake 2.8\bin\cmake.exe" set CMAKEHOME=%ProgramFiles32%\CMake 2.8
if exist "%ProgramFiles%\CMake 2.8\cmake.exe" set CMAKEHOME=%ProgramFiles%\CMake 2.8
if exist "%_cmake%\bin\cmake.exe" set CMAKEHOME=%_cmake%
if "%CMAKEHOME%" == "" (
  echo.  CMake not found
  goto endcmake
)
echo.  CMake home: %CMAKEHOME%
set _path=%CMAKEHOME%\bin;%_path%

if exist "%_ci_prop_file%" goto cicmake
goto endcmake

:cicmake
echo.CMAKEHOME=%CMAKEHOME% >>"%_ci_prop_file%"

:endcmake

:sevenzip
echo.
echo.Setting 7-Zip Environment

if exist "%ProgramFiles32%\7-zip\7z.exe" set SEVENZIPHOME=%ProgramFiles32%\7-zip
if exist "%ProgramFiles%\7-zip\7z.exe" set SEVENZIPHOME=%ProgramFiles%\7-zip

if exist %_seven_zip%7z.exe goto inisevenzip 
goto noinisevenzip

:inisevenzip
  set SEVENZIPHOME=%_seven_zip%
  if "%SEVENZIPHOME:~-1%"=="\" SET SEVENZIPHOME=%SEVENZIPHOME:~0,-1%
  goto sevenzipfound

:noinisevenzip   

if "%SEVENZIPHOME%" == "" ( 
  echo.  7-Zip not found
  goto endsevenzip
)

:sevenzipfound

echo.  7-Zip home: %SEVENZIPHOME%
set _path=%SEVENZIPHOME%;%_path%

if exist "%_ci_prop_file%" goto cisevenzip
goto endsevenzip

:cisevenzip
echo.SEVENZIPHOME=%SEVENZIPHOME% >>"%_ci_prop_file%" 

:endsevenzip

:pydevdebug

echo.
echo.Setting PyDev Debug Environment
if exist "%_pydev_debug%\pydevd.py" set PYDEVDEBUG=%_pydev_debug%

if "%PYDEVDEBUG%" == "" (
  echo.  Pydev Debug not found
  goto endpydevdebug
)
echo.  PyDev Debug home: %PYDEVDEBUG%

if exist "%_ci_prop_file%" goto cipydevdebug
goto endpydevdebug

:cipydevdebug
echo.PYDEVDEBUG=%PYDEVDEBUG% >>"%_ci_prop_file%"

:endpydevdebug


rem *****************
rem *** Libraries ***
rem *****************


:qt
echo.
echo.Setting Qt Environment
rem 1. registry?
rem 2. check for some standard file to ensure _qt_path actually contains the Qt SDK?
rem    (similar to NSIS, Git, and Python checks)
if exist "%_qt_path%" set QTHOME=%_qt_path%

if "%QTHOME%" == "" (
    echo.  Qt not found
    goto endqt
)

echo.  Qt home: %QTHOME%
if exist "%_ci_prop_file%" goto ciqt
goto nociqt

:ciqt
echo.QTHOME=%QTHOME% >>"%_ci_prop_file%" 

:nociqt

for %%A in (Qt5.2.1\5.2.1,5.1.1,4.8.5,4.7.4,4.7.3,4.7.2,4.7.1) do (
  if exist "%QTHOME%\Qt\%%A" (
      set QTVERSION=%%A
      goto qtversionfound
  )  
)

if exist "%QTHOME%" (
  goto qtversionfound
)

if "%QTVERSION%" == "" (
  echo.  Qt version not found
  goto endqt
)

:qtversionfound

echo.  Qt version: %QTVERSION%

if exist "%_ci_prop_file%" goto ciqtversion
goto nociqtversion

:ciqtversion
echo.QTVERSION=%QTVERSION% >>"%_ci_prop_file%" 

:nociqtversion

if exist "%QTHOME%\Qt\%QTVERSION%\bin" (
  set QTDIR=%QTHOME%\Qt\%QTVERSION%
  goto qtdirectoryfound
) 

for %%A in (mingw,msvc2012_64_opengl) do (
  if exist "%QTHOME%\Qt\%QTVERSION%\%%A" (
     set QTDIR=%QTHOME%\Qt\%QTVERSION%\%%A
	 goto qtdirectoryfound
  )
) 

if "%QTDIR%" == "" (
  echo.  Qt directory not found
  goto endqt
)

:qtdirectoryfound

if exist "%QTDIR%\include" ( 
  set QTINC=%QTDIR%\include
)
set _include=%QTINC%;%_include%

if exist "%QTDIR%\lib" ( 
  set QTLIB=%QTDIR%\lib
)

set _lib=%QTLIB%;%_lib%

echo.
echo.  Qt directory: %QTDIR%
echo.  Qt include: %QTINC%
echo.  Qt Lib: %QTLIB%

if exist "%_ci_prop_file%" goto ciqtsets
goto endqt

:ciqtsets
echo.%QTDIR%>>"%_ci_prop_file%"
echo.%QTINC%>>"%_ci_prop_file%"
echo.%QTLIB%>>"%_ci_prop_file%"

:endqt


:qmake
echo.
echo.Setting QMake Environment
if exist "%_qmake%\qmake.exe" set QMAKEHOME=%_qmake%

if "%QMAKEHOME%" == "" (
 echo.  QMAKE not found
 goto endqmake
)

echo.  QMAKE home: %QMAKEHOME%
set _path=%QMAKEHOME%;%_path%
if exist "%_ci_prop_file%" (
echo.QMAKEHOME=%QMAKEHOME% >>"%_ci_prop_file%"
)
:endqmake

:swig

echo.
echo.Setting SWIG Environment
if exist "%_swig%\swig.exe" set SWIGHOME=%_swig%
if "%SWIGHOME%" == "" (
  echo.  SWIG not found
  goto endswig
)
echo.  SWIG home: %SWIGHOME%
set _path=%SWIGHOME%;%_path%
if exist "%_ci_prop_file%" (
echo.SWIGHOME=%SWIGHOME% >>"%_ci_prop_file%"
)
:endswig


:boost
echo.
echo.Setting BOOST Environment

if exist "%_boostinc%" set BOOST_INCLUDEDIR=%_boostinc% 
if "%BOOST_INCLUDEDIR%" == "" (
  echo.  BOOST Include Directory not found
  goto endboost
)
echo.  BOOST Include Directory: %BOOST_INCLUDEDIR%
if exist "%_ci_prop_file%" (
echo.BOOST_INCLUDEDIR=%BOOST_INCLUDEDIR% >>"%_ci_prop_file%"
)

if exist "%_boostlib%" set BOOST_LIBRARYDIR=%_boostlib%
if "%BOOST_LIBRARYDIR%" == "" (
  echo.  BOOST Library not found
  goto endboost
)
set _path=%BOOST_LIBRARYDIR%;%_path%
echo.  BOOST Library: %BOOST_LIBRARYDIR%
if exist "%_ci_prop_file%" (
echo.BOOST_LIBRARYDIR=%BOOST_LIBRARYDIR% >>"%_ci_prop_file%"
)
:endboost


rem ***************
rem ** Compilers **
rem ***************


:compilers
echo.
echo.Setting Compiler Environment (%_compiler_type%, %_arch_type% bit)
if "%_compiler_type%x%_arch_type%" == "x32" goto auto_set_compiler32
if "%_compiler_type%x%_arch_type%" == "x64" goto auto_set_compiler64

if "%_compiler_type%x%_arch_type%" == "msvc2012x32" goto msvc2012x32
if "%_compiler_type%x%_arch_type%" == "msvc2012x64" goto msvc2012x64
if "%_compiler_type%x%_arch_type%" == "msvc2010x32" goto msvc2010x32
if "%_compiler_type%x%_arch_type%" == "msvc2010x64" goto msvc2010x64
if "%_compiler_type%x%_arch_type%" == "msvc2008x32" goto msvc2008x32
if "%_compiler_type%x%_arch_type%" == "msvc2008x64" goto msvc2008x64
if "%_compiler_type%x%_arch_type%" == "mingwx32" goto mingwx32
if "%_compiler_type%x%_arch_type%" == "mingwx64" goto mingwx64
if "%_compiler_type%x%_arch_type%" == "sdk60x32" goto sdk60x32
if "%_compiler_type%x%_arch_type%" == "sdk60x64" goto sdk60x64
if "%_compiler_type%x%_arch_type%" == "sdk70x32" goto sdk70x32
if "%_compiler_type%x%_arch_type%" == "sdk70x64" goto sdk70x64
if "%_compiler_type%x%_arch_type%" == "sdk71x32" goto sdk71x32
if "%_compiler_type%x%_arch_type%" == "sdk71x64" goto sdk71x64
goto compilernotfound

:auto_set_compiler32
if not "%_msvc2012%" == "" goto msvc2012x32
if not "%_msvc2010%" == "" goto msvc2010x32
if not "%_msvc2008%" == "" goto msvc2008x32

:auto_set_compiler64
if not "%_msvc2012%" == "" goto msvc2012x64
if not "%_msvc2010%" == "" goto msvc2010x64
if not "%_msvc2008%" == "" goto msvc2008x64

:msvc2012x64
if not exist "%_msvc2012%\bin\vcvars64.bat" goto compilernotfound
call "%_msvc2012%\bin\vcvars64.bat"
goto python_msvc

:msvc2012x32
if not exist "%_msvc2012%\bin\vcvars32.bat" goto compilernotfound
call "%_msvc2012%\bin\vcvars32.bat"
goto python_msvc

:msvc2010x64
if not exist "%_msvc2010%\bin\vcvars64.bat" goto compilernotfound
call "%_msvc2010%\bin\vcvars64.bat"
goto python_msvc

:msvc2010x32
if not exist "%_msvc2010%\bin\vcvars32.bat" goto compilernotfound
call "%_msvc2010%\bin\vcvars32.bat"
goto python_msvc

:msvc2008x64
if not exist "%_msvc2008%\bin\vcvars64.bat" goto compilernotfound
call "%_msvc2008%\bin\vcvars64.bat"
goto python_msvc

:msvc2008x32
if not exist "%_msvc2008%\bin\vcvars32.bat" goto compilernotfound
call "%_msvc2008%\bin\vcvars32.bat"
goto python_msvc

:sdk60x32
if not exist "%_ms_sdk_six%\vc\bin" goto compilernotfound
set _path="%_ms_sdk_six%\vc\bin";%_path% 
set INCLUDE="%_ms_sdk_six%\vc\include";%INCLUDE%
set LIB="%_ms_sdk_six%\vc\lib";%LIB% 
goto python_msvc

:sdk60x64
if not exist "%_ms_sdk_six%\vc\bin\x64" goto compilernotfound
set _path="%_ms_sdk_six%\vc\bin\x64";%_path%
set INCLUDE="%_ms_sdk_six%\vc\include";%INCLUDE%
set LIB="%_ms_sdk_six%\vc\lib\x64";%LIB% 
goto python_msvc

:sdk70x32
if not exist "%_ms_sdk_seven%\bin\SetEnv.cmd" goto compilernotfound
call "%_ms_sdk_seven%\bin\SetEnv.cmd" /x86 /release /xp
goto python_msvc

:sdk70x64
if not exist "%_ms_sdk_seven%\bin\SetEnv.cmd" goto compilernotfound
call "%_ms_sdk_seven%\bin\SetEnv.cmd" /x64 /release /xp
goto python_msvc

:sdk71x32
if not exist "%_ms_sdk_seven_one%\bin\SetEnv.cmd" goto compilernotfound
call "%_ms_sdk_seven_one%\bin\SetEnv.cmd" /x86 /release /xp
goto python_msvc

:sdk71x64
if not exist "%_ms_sdk_seven_one%\bin\SetEnv.cmd" goto compilernotfound
call "%_ms_sdk_seven_one%\bin\SetEnv.cmd" /x64 /release /xp
goto python_msvc

:mingwx32
if "%QTDIR%" == "" goto mingw_standalone
if not "%QTDIR%" == "" goto mingw_qt

:mingwx64
echo.  Compiler not supported by buildenv.
goto endcompiler

:mingw_standalone
if exist "C:\mingw\bin" (
  echo.  Using standalone MinGW
  set _path=C:\mingw\bin;%_path%
  goto python_mingw
) else (
  echo.  MinGW not found
  goto endcompiler
)

:mingw_qt
echo.Using MinGW bundled with Qt
set _path=%QTDIR%\bin;%QTHOME%\mingw\bin;%_path%
goto python_mingw

:python_msvc
if exist %PYTHONFOLDER% (
echo.Setting python compiler for msvc.
echo.  [build]> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
echo.  compiler=msvc>> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
)
goto endcompiler


:python_mingw
if exist %PYTHONFOLDER% (
echo.Setting python compiler for mingw32.
echo.  [build]> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
echo.  compiler=mingw32>> "%PYTHONFOLDER%\Lib\distutils\distutils.cfg"
)
goto endcompiler

:compilernotfound
echo.  Compiler not found

:endcompiler


rem **************
rem ** Includes **
rem **************

if exist "%_ci_prop_file%" goto ciincludes
goto endincludes

:ciincludes
echo.INCLUDE=%_include% >>"%_ci_prop_file%"
echo.LIB=%_lib% >>"%_ci_prop_file%"

:endincludes

rem **************
rem ** Start-Up **
rem **************

:path
set PATH=%_path%%PATH%
if exist "%_ci_prop_file%" goto cipath
goto endpath

:cipath
echo.PATH=%PATH%>>"%_ci_prop_file%"

:endpath

:workfolder
if exist "%HOMEDRIVE%%HOMEPATH%\%_work_folder%" set _work_folder=%HOMEDRIVE%%HOMEPATH%\%_work_folder%
echo.
echo.Changing to directory: 
echo.%_work_folder%
echo.
if not exist "%_work_folder%" goto workfoldernotfound
cd /d "%_work_folder%"
goto endworkfolder

:workfoldernotfound
echo.  Directory not found.

:endworkfolder

:end

rem **************
rem ** Clean Up **
rem **************

rem architecture:

set ProgramFiles32=
set _work_folder=
set _arch_type=
set _ci_prop_file=
set _path=

rem compiler: 

set _compiler_type=
set _msvc2008_32=
set _msvc2010_32=
set _msvc2012_32=
set _msvc2008_64=
set _msvc2010_64=
set _msvc2012_64=

set _ms_sdk_six=
set _ms_sdk_seven=
set _ms_sdk_seven_one=

set _blender=

set _python_path=

set _git_path=
set _git_path=
set _nsis_path=
set _seven_zip=
set _seven_zip=
set _cmake=
set _pydev_debug=
set _qmake=

set _include=
set _lib=

set _qt_path=
set _swig=
set _boostlib=
set _boostinc=

set SWITCHPARSE=
set SWITCH=
set VALUE=

:eof
