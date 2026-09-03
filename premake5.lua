workspace "zork-clone-builder"
    architecture "x64"
    language "C++"
    cppdialect "C++17"

    startproject "zork-clone-builder"
    
    configurations { "debug", "release" }

    filter "system:windows"
        systemversion "latest"
        defines "PLATFORM_WINDOWS"
        staticruntime "on"
        entrypoint "mainCRTStartup"
    filter "configurations:debug"
        defines "DEBUG"
        symbols "on"
    filter "configurations:release"
        defines "RELEASE"
        optimize "on"

build = "%{cfg.buildcfg}-%{cfg.system}/"
bin = "%{wks.location}/bin/"
bin_int = "%{wks.location}/bin/bin-int/"

includes = {}
includes["imgui"] = "vendor/imgui"
includes["sdl3"] = "vendor/sdl3/include"

includes["lua54"] = "vendor/lua54/include"
includes["sol2"] = "vendor/sol2/include"

group "dependencies"
    include "vendor/imgui"
group ""

project "zork-clone-builder"
    location "zork-clone-builder"
    
    targetdir (bin .. "zork-clone-builder/" .. build)
    objdir (bin_int .. "zork-clone-builder/" .. build)
    
    files {
        "%{prj.location}/src/**.cpp",
        "%{prj.location}/src/**.h"
    }
    includedirs {
        "%{prj.location}/src",
        
        "%{includes.imgui}",
        "%{includes.sdl3}",

        "%{includes.lua54}",
        "%{includes.sol2}"
    }
    libdirs {
        "vendor/sdl3/lib/x64",
        
        "vendor/lua54",
    }
    links {
        "imgui",
        "SDL3.lib",
        
        "lua54.lib"
    }
    
    postbuildcommands {
        ("{COPY} %{wks.location}vendor/sdl3/lib/x64/SDL3.dll %{cfg.targetdir}"),
        
        ("{COPY} %{wks.location}examples/zork-script.lua %{cfg.targetdir}"),
        ("{COPY} %{wks.location}examples/zork-script.lua %{prj.location}"),
	}
    
    filter "configurations:debug"
        kind "ConsoleApp"
    filter "configurations:release"
        kind "WindowedApp"
        defines "ZORK_DISABLE_LOGGING"
