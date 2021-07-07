includes("joj.lua")

-- There is really no need to set project name and version.
-- set_project("example_project")
-- set_version("0.0.1")
set_xmakever("2.5.5")

-- There is no need to have release mode, right?
add_rules("mode.debug", "mode.coverage", "mode.valgrind")


-- dependencies for unit test
-- add_requires("conan::boost-ext-ut/1.1.8")

-- Set your target name
target("example")
  set_default(true)
  set_kind("binary")

  -- I was to that I'm allowed to use C++11
  set_languages("cxx11")

  -- This is equivalent to -Wall -Wextra -Werror
  set_warnings("allextra", "error")

  -- It seems that TAs will assume you run your binary under the root directory
  -- of your project.
  set_rundir("$(projectdir)")
  add_files("src/*.cpp")

  -- Enable JOJ source files packaging.
  add_rules("joj")
  set_values("joj.files", "main.cpp", "greeter.h", "greeter.cpp")
  set_values("joj.format", "zip")
  set_values("joj.source_dir", "src")
  set_values("joj.archive_dir", "$(projectdir)/upload")

-- Sample unit test target
-- target("test")
--   add_packages("conan::boost-ext-ut/1.1.8")
--   set_kind("binary")
--   set_languages("cxx20")
--   add_files("src/*.cpp|main.cpp", "test/main.cpp")
--   add_includedirs("src")
--
--   -- generate coverage report under coverage mode
--   after_run(function (target)
--     if is_mode("coverage") then
--       os.execv("grcov", { ".", "-s", "src", "--binary-path", target:objectdir(), "-t", "html", "--branch", "--ignore-not-existing", "-o", "./coverage" })
--     end
--   end)
