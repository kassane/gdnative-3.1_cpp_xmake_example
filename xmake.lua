
-- add modes: debug and release 
add_rules("mode.release","mode.debug")

-- add target
target("gdexample")

    set_kind("shared")

    if is_plat("linux") then
        set_targetdir("$(projectdir)/demo/bin/x11")

    elseif is_plat("windows") then
        set_targetdir("$(projectdir)/demo/bin/win$(arch)")
    
    else
        set_targetdir("$(projectdir)/demo/bin/osx")
    end

    add_includedirs("$(projectdir)/godot-cpp/include", "$(projectdir)/godot-cpp/include/core", "$(projectdir)/godot-cpp/godot_headers", "$(projectdir)/godot-cpp/include/gen")
--
    if os.exists("$(projectdir)/godot-cpp/bin/*.a") then
        before_build (function (target)
            print("Building godot-cpp:")
            -- os.cp("$(projectdir)/godot-cpp/*.py", "$(projectdir)")
            -- os.execv("python", {"-c","\"from godot-cpp.binding_generator.py import binding_generator; binding_generator.generate_bindings('/godot-cpp/godot_headers/api.json')\""})
            if is_mode("debug") then
                os.execv("cmake", {"godot-cpp","-B","build", "-DCMAKE_BUILD_TYPE=debug"})
            else
                os.execv("cmake", {"godot-cpp","-B","build", "-DCMAKE_BUILD_TYPE=release"})
            end
            os.execv("cmake", {"--build", "build"})
        end)
    end

    -- add_deps("godot-cpp")
    if is_arch("x86_64") then
        add_links("godot-cpp.$(plat).$(mode).64")
    else
        add_links("godot-cpp.$(plat).$(mode).32")
    end
    add_linkdirs("$(projectdir)/godot-cpp/bin")

    add_files("src/*.cpp") 

-- add target
-- target("gdnative_demo")

--     -- set kind
--     set_kind("binary")

--     -- add deps
--     add_deps("gdnative")

--     -- add files
--     add_files("src/test.cpp") 



--
-- FAQ
--
-- You can enter the project directory firstly before building project.
--   
--   $ cd projectdir
-- 
-- 1. How to build project?
--   
--   $ xmake
--
-- 2. How to configure project?
--
--   $ xmake f -p [macosx|linux|iphoneos ..] -a [x86_64|i386|arm64 ..] -m [debug|release]
--
-- 3. Where is the build output directory?
--
--   The default output directory is `$(projectdir)/build` and you can configure the output directory.
--
--   $ xmake f -o outputdir
--   $ xmake
--
-- 4. How to run and debug target after building project?
--
--   $ xmake run [targetname]
--   $ xmake run -d [targetname]
--
-- 5. How to install target to the system directory or other output directory?
--
--   $ xmake install 
--   $ xmake install -o installdir
--
-- 6. Add some frequently-used compilation flags in xmake.lua
--
-- @code 
--    -- add macro defination
--    add_defines("NDEBUG", "_GNU_SOURCE=1")
--
--    -- set warning all as error
--    set_warnings("all", "error")
--
--    -- set language: c99, c++11
--    set_languages("c99", "cxx11")
--
--    -- set optimization: none, faster, fastest, smallest 
--    set_optimize("fastest")
--    
--    -- add include search directories
--    add_includedirs("/usr/include", "/usr/local/include")
--
--    -- add link libraries and search directories
--    add_links("tbox", "z", "pthread")
--    add_linkdirs("/usr/local/lib", "/usr/lib")
--
--    -- add compilation and link flags
--    add_cxflags("-stdnolib", "-fno-strict-aliasing")
--    add_ldflags("-L/usr/local/lib", "-lpthread", {force = true})
--
-- @endcode
--
-- 7. If you want to known more usage about xmake, please see http://xmake.io/#/home
--
    
