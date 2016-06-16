-- http://industriousone.com/scripting-reference
-- https://github.com/premake/premake-core/wiki

local action = _ACTION or ""

solution "opencv-aruco"
    location ("_project")
    configurations { "Debug", "Release" }
    platforms {"x64", "x86"}
    language "C++"
    kind "ConsoleApp"

    configuration "vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }

        configuration "x86"
            libdirs {
                "../opencv-lib/vs2013-x86",
                "x86",
            }
            targetdir ("x86")

        configuration "x64"
            libdirs {
                "../opencv-lib/vs2013-x64",
                "x64",
            }
            targetdir ("x64")

        os.mkdir("x86");
        os.copyfile("../opencv-lib/vs2013-x86/opencv_world300d.dll", "x86/opencv_world300d.dll")
        os.copyfile("../opencv-lib/vs2013-x86/opencv_world300.dll", "x86/opencv_world300.dll")
        os.mkdir("x64");
        os.copyfile("../opencv-lib/vs2013-x64/opencv_world300d.dll", "x64/opencv_world300d.dll")
        os.copyfile("../opencv-lib/vs2013-x64/opencv_world300.dll", "x64/opencv_world300.dll")
        os.copyfile("../opencv-lib/vs2013-x64/OpenNI2.dll", "x64/OpenNI2.dll")

    flags {
        "MultiProcessorCompile"
    }

    configuration "Debug"
        links {
            "opencv_world300d.lib"
        }

    configuration "Release"
        links {
            "opencv_world300.lib"
        }

    configuration "Debug"
        defines { "DEBUG" }
        flags { "Symbols"}
        targetsuffix "-d"

    configuration "Release"
        defines { "NDEBUG" }
        flags { "Optimize"}

-- 
    project "opencv-aruco"
        kind "StaticLib"

        includedirs {
            "include",
            "src",
            "../opencv-lib/include",
        }

        files {
            "include/opencv2/*",
            "src/*",
        }

        defines {

        }

    function create_app_project( app_path )
        leaf_name = string.sub(app_path, string.len("samples/") + 1);

        project (leaf_name)

            includedirs {
                "include",
                "../opencv-lib/include",
                "samples/" .. leaf_name .. "/include",
            }

            files {
                "samples/" .. leaf_name .. "/**",
            }


            configuration "Debug"
                links {
                    "opencv-aruco-d.lib",
                }
            configuration "Release"
                links {
                    "opencv-aruco.lib",
                }
    end

    local apps = os.matchdirs("samples/*")
    for _, app in ipairs(apps) do
        create_app_project(app)
    end
