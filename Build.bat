@echo off

rem Customisable cmake configuration command
set "CMAKE_CONFIG=cmake -S . -B Build -G Ninja"

rem Customisable cmake build command
set "CMAKE_BUILD=cmake --build Build"

rem Customisable cmake install command
set "CMAKE_INSTALL=cmake --install Build"

REM if exist Build (
REM 	echo Build directory found. Clearing...
REM 	rmdir /s /q Build
REM ) else (
REM 	echo No Build directory found.
REM )

if exist Bin (
	echo Bin directory found. Clearing...
	rmdir /s /q Bin
) else (
	echo No Bin directory found.
)

if exist Include (
	echo Include directory found. Clearing...
	rmdir /s /q Include
) else (
	echo No Include directory found.
)

rem Engine && SDL
echo ENGINE PASS
%CMAKE_CONFIG% -D ENGINE_DO_BUILD=ON -D ENGINE_DO_INSTALL=ON -D ENGINE_DO_INSTALL_HEADERS=ON -D GAME_DO_BUILD=OFF -D GAME_DO_INSTALL=OFF
%CMAKE_BUILD%
%CMAKE_INSTALL%

rem Game
echo GAME PASS
%CMAKE_CONFIG% -D ENGINE_DO_BUILD=OFF -D ENGINE_DO_INSTALL=OFF -D ENGINE_DO_INSTALL_HEADERS=OFF -D GAME_DO_BUILD=ON -D GAME_DO_INSTALL=ON
%CMAKE_BUILD%
%CMAKE_INSTALL%
