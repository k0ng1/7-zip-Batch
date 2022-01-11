@echo off


set z7z="%ProgramW6432%\7-Zip-Zstandard\7z.exe"
@REM set base=%z7z% %command% "%%X.%format%" "%%X\" -mx%level% -m0=%method% -mhe=%encFilename% %deleteAfter% %sfx%
@rem all variable default is 0
@rem 0 is folder
@rem 1 is file
set inputType=0


set subfolder=off

@REM default is a
@rem a is Add
@REM u is Update
@REM x is Extract
set command=a

@REM default is 7z
@REM 0 is 7z
@REM 1 is zip
set format=7z

@REM default is Zstd
@REM 0 is copy
@REM 1 is Zstd
@REM 2 is Brotli
@REM 3 is LZ4
@REM 4 is LZ5
@REM 5 is Lizard
@REM 6 is LZMA
@REM 7 is LZMA2
@REM 8 is BZip2
@REM 9 is FLZMA2
set method=Zstd

@REM default is 5
set level=5

@REM default is fast
set levelString=Fast

set password=
@REM set passwordWithCommand=

@REM default is false
set encFilename=0

@REM default is false
set deleteAfter=0

@REM default is false
set sfx=0

set volume=
@REM Output filename
set outFilename=%%X

@REM default is zstd
set gotoLevel=:levelZstd

@REM default is 7z
set start=:startAdd7z
set blockSize=

:mainMenu
cls
echo.
echo MainMenu
echo.

if [%command%] == [a] (
	echo 1 - Command [Add]
) else if [%command%] == [u] (
	echo 1 - Command [Update]
) else if [%command%] == [x] (
	echo 1 - Command [Extract]
)

if %inputType% equ 0 (echo 2 - Input Type [Folders]) else (echo 2 - Input Type [Files])
echo 3 - Archive Format [%format%]

echo 4 - Compression Method [%method%]
echo 5 - Compression Level [%levelString% (%level%)]
echo 6 - Password [%password%]
if [%format%]==[7z] (if %encFilename% equ 0 (echo 7 - Encrypt Filename [off]) else (echo 7 - Encrypt Filename [on]))
if %deleteAfter% == 0 (echo 8 - Delete After [off]) else (echo 8 - Delete After [on])
if %sfx% == 0 (echo 9 - SFX Archive [off]) else (echo 9 - SFX Archive [on])
echo 10 - Split Volume [%volume%]
echo 11 - Subfolder [%subfolder%]
echo.
echo s - Start
echo q - Exit

set base=%z7z% %command% "%outFilename%.%format%" "%%X\" -mx%level% -m0=%method%
if %encFilename% equ 1 (set base=%base% -mhe=on)
if %deleteAfter% equ 1 (set base=%base% -sdel)
if %sfx% equ 1 (set base=%base% -sfx7z.sfx)
if [%password%] neq [] (set base=%base% -p"%password%")
if [%volume%] neq [] (set base=%base% -v%volume%)
echo.
echo.
echo %base%
echo.
echo.
@REM choice /c 12345678sq /n /m "Choose a menu option, or press 0 to Exit: "
set /p _mainmenu="Choose a menu option, or press 0 to Exit: "
@REM set _mainmenu=%errorlevel%
if %_mainmenu% == 1 goto :commandMenu
if %_mainmenu% == 2 (if %inputType% equ 0 (set inputType=1) else (set inputType=0))& goto :mainMenu
if %_mainmenu% == 3 (if [%format%] == [7z] (set format=zip& set start=:startAddZip) else (set format=7z& set start=:startAdd7z))& goto :mainMenu
if %_mainmenu% == 4 goto :methodMenu
if %_mainmenu% == 5 goto %gotoLevel%
if %_mainmenu% == 6 goto :passwordMenu
if %_mainmenu% == 7 (if %encFilename% equ 1 (set encFilename=0) else (set encFilename=1))& goto :mainMenu
if %_mainmenu% == 8 (if %deleteAfter% equ 1 (set deleteAfter=0) else (set deleteAfter=1))& goto :mainMenu
if %_mainmenu% == 9 (if %sfx% equ 1 (set sfx=0& set format=7z) else (set sfx=1& set format=exe))& goto :mainMenu
if %_mainmenu% == 10 goto :volumeMenu
if %_mainmenu% == 11 (if [%subfolder%]==[on] (set subfolder=off& set outFilename=%%X) else (set subfolder=on& set outFilename=%%X\%%X))& goto :mainMenu
if [%_mainmenu%] equ [s] goto %start%
if [%_mainmenu%] equ [q] goto :eof
goto :mainMenu

:commandMenu
cls
echo Command
echo.
echo 1 - Add
echo 2 - Update
echo 3 - Extract
echo.
echo.
choice /c 123 /n /m "Choose a menu option, or press 0 to Exit: "
set _commandMenu=%errorlevel%
if %_commandMenu% equ 1 (set command=a& goto :mainMenu)
if %_commandMenu% equ 2 (set command=u& goto :mainMenu)
if %_commandMenu% equ 3 (set command=x& goto :mainMenu)
goto :mainMenu

:commandAddMenu

:methodMenu
cls
echo Compression Method
echo.
echo 1 - Zstandard
echo 2 - Brotli
echo 3 - LZ4
echo 4 - LZ5
echo 5 - Lizard 
echo 6 - LZMA2
echo.
echo.
choice /c 123456 /n /m "Choose a menu option, or press 0 to Exit: "
set _method=%errorlevel%
if %_method% equ 1 set method=zstd& set gotoLevel=:levelZstd
if %_method% equ 2 set method=Brotli
if %_method% equ 3 set method=LZ4
if %_method% equ 4 set method=LZ5
if %_method% equ 5 set method=Lizard
if %_method% equ 6 set method=LZMA2
goto mainMenu

:levelZstd
cls
echo Compression Level Zstd
echo.
echo 1 - Store
echo 2 - Fastest
echo 3 - Fast
echo 4 - Normal
echo 5 - Maximum
echo 6 - Ultra
echo m - Manual
echo.
echo.
choice /c 123456m /n /m "Choose a menu option, or press 0 to Exit: "
set _levelZstd=%errorlevel%
if %_levelZstd% equ 1 (set level=1& set levelString=Store)& goto :mainMenu
if %_levelZstd% equ 2 (set level=3& set levelString=Fastest)& goto :mainMenu
if %_levelZstd% equ 3 (set level=5& set levelString=Fast)& goto :mainMenu
if %_levelZstd% equ 4 (set level=11& set levelString=Normal)& goto :mainMenu
if %_levelZstd% equ 5 (set level=17& set levelString=Maximum)& goto :mainMenu
if %_levelZstd% equ 6 (set level=22& set levelString=Ultra)& goto :mainMenu
if %_levelZstd% equ 7 (
	echo (1-22)
	set /p level=Type Level then press ENTER: 
	set levelString=Manual (%level%)
	goto :mainMenu
)

:passwordMenu
set password=
@REM set passwordWithCommand=
set /p password=Type Password then press ENTER: 
@REM if [%password%] == [-p] (
@REM 	set passwordWithCommand=
@REM ) else (
@REM 	set "passwordWithCommand=-p%password%"
@REM )
goto :mainMenu

:volumeMenu
cls
echo Split Volume
echo.
echo 1 - 10m
echo 2 - 100m
echo 3 - 1000m
echo 4 - 650m - CD
echo 5 - 700m - CD
echo 6 - 4092m - FAT
echo 7 - 4480m - DVD
echo 8 - 8128m - DVD DL
echo.
echo d - Disable
echo m - Manual
echo.
echo.
choice /c 12345678dm /n /m "Choose a menu option, or press 0 to Exit: "
set _volumeSize=%errorlevel%
if %_volumeSize% equ 1 (set volume=10m)& goto :mainMenu
if %_volumeSize% equ 2 (set volume=100m)& goto :mainMenu
if %_volumeSize% equ 3 (set volume=1000m)& goto :mainMenu
if %_volumeSize% equ 4 (set volume=650m)& goto :mainMenu
if %_volumeSize% equ 5 (set volume=700m)& goto :mainMenu
if %_volumeSize% equ 6 (set volume=4092m)& goto :mainMenu
if %_volumeSize% equ 7 (set volume=4480m)& goto :mainMenu
if %_volumeSize% equ 8 (set volume=8128m)& goto :mainMenu
if %_volumeSize% equ 9 (set volume=)& goto :mainMenu
if %_volumeSize% equ 10 (
	set /p volume=Type Volume Size then press ENTER: 
	goto :mainMenu
)

:SubfolderMunu


:startAdd7z
for /d %%X in (*) do (
	echo %base%
)
pause
goto :mainMenu

:startAddZip
