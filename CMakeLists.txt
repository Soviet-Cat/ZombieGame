# This file is apart of ZombieGame
# Copyright (c) 2026 Soviet-Cat
# See LICENSE.md for license details

cmake_minimum_required(VERSION 3.20)
project(ZombieGame)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}")

# Options
option(ENGINE_DO_BUILD "Whether to build Engine library. Defaults to OFF." OFF)
option(ENGINE_DO_INSTALL "Whether to install Engine library. Defaults to OFF." OFF)
option(ENGINE_DO_INSTALL_HEADERS "Whether to install Engine library headers. Defaults to OFF." OFF)
option(GAME_DO_BUILD "Whether to build Game executable. Defaults to OFF." OFF)
option(GAME_DO_INSTALL "Whether to install Game executable. Defaults to OFF." OFF)

# SDL
add_subdirectory(Vendor/SDL EXCLUDE_FROM_ALL)

# Engine Library
set(Engine_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Engine")
file(GLOB_RECURSE Engine_SOURCES "${Engine_DIR}/**/*.c" "${Engine_DIR}/*.c")
list(APPEND Engine_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/Vendor/glad/src/glad.c")
file(GLOB_RECURSE Engine_PUB_HEADERS "${Engine_DIR}/**/*.h" "${Engine_DIR}/*.h")
file(GLOB_RECURSE Engine_PRV_HEADERS "${Engine_DIR}/**/*.prv.h" "${Engine_DIR}/*.prv.h")
set(Engine_HEADERS ${Engine_PUB_HEADERS})
list(REMOVE_ITEM Engine_HEADERS ${Engine_PRV_HEADERS})

if(${ENGINE_DO_BUILD})
	add_library(Engine SHARED ${Engine_SOURCES})
	target_include_directories(Engine PRIVATE
		${Engine_DIR}
		"${CMAKE_CURRENT_SOURCE_DIR}/Vendor/glad/include"	
		"${CMAKE_CURRENT_SOURCE_DIR}/Vendor/SDL/include/SDL3"
	)
	target_link_libraries(Engine PRIVATE
		SDL3::SDL3
	)

	set_target_properties(Engine PROPERTIES
		OUTPUT_NAME "ZombieGameEngine"
	)
endif()

if(${ENGINE_DO_INSTALL})
	install(
		TARGETS Engine
		RUNTIME DESTINATION Bin
		LIBRARY DESTINATION Bin
		ARCHIVE DESTINATION Bin
	)
	install(
		FILES $<TARGET_FILE:SDL3::SDL3>
		DESTINATION Bin
	)
endif()

if(${ENGINE_DO_INSTALL_HEADERS})
	foreach(header IN LISTS Engine_HEADERS)
		file(RELATIVE_PATH relative ${Engine_DIR} ${header})
		get_filename_component(directory ${relative} DIRECTORY)
		install(
			FILES ${header}
			DESTINATION Include/Engine/${dir}
		)
	endforeach()
endif()

# Game Executable
set(Game_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Game")
file(GLOB_RECURSE Game_SOURCES "${Game_DIR}/**/*.c" "${Game_DIR}/*.c")
list(APPEND Game_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/Vendor/glad/src/glad.c")

if(${GAME_DO_BUILD})
	add_executable(Game ${Game_SOURCES})
	target_include_directories(Game PRIVATE
		"${CMAKE_INSTALL_PREFIX}/Include/Engine"
		"${CMAKE_CURRENT_SOURCE_DIR}/Vendor/glad/include"
		"${CMAKE_CURRENT_SOURCE_DIR}/Vendor/SDL/include/SDL3"
	)
	target_link_libraries(Game PRIVATE
		SDL3::SDL3
	)

	set_target_properties(Game PROPERTIES
		OUTPUT_NAME "ZombieGame"
	)
endif()

if(${GAME_DO_INSTALL})
	install(
		TARGETS Game
		RUNTIME DESTINATION Bin
		LIBRARY DESTINATION Bin
		ARCHIVE DESTINATION Bin
	)
endif()
