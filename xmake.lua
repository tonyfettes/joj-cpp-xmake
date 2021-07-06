set_project("example_project")
set_version("0.0.1")
-- I'm using xmake 2.5.4 when I write this file.
set_xmakever("2.5.4")

-- There is no need to have release mode, right?
add_rules("mode.debug", "mode.coverage", "mode.valgrind")

-- dependencies for unit test
add_requires("conan::boost-ext-ut/1.1.8")

-- rules to package source files as an archive to be submitted on JOJ
rule("joj")
  on_package(function (target)

    -- If files that needed to be uploaded are not specified, issues an error.
    assert(target:values("joj.files") ~= nil, "joj.files must be specified, e.g. add_values(\"joj.files\", \"src/main.cpp\")")
    assert(target:values("joj.format") ~= nil, "joj.format must be specified, e.g. set_values(\"joj.format\", \"zip\")")

    local archive_format = target:values("joj.format")
    local archive_name = nil
    if not target:values("joj.archive_filename_no_ext") then
      archive_name = target:name() .. "." .. archive_format
    else
      archive_name = target:values("joj.archive_filename_no_ext") .. "." .. archive_format
    end
    local archive_command = nil
    local archive_param = nil
    local archive_dir = target:values("joj.archive_dir") or "$(projectdir)/upload"
    local source_dir = target:values("joj.source_dir") or "$(projectdir)"
  
    -- If archive directory does not exist, we make it.
    if not os.exists(archive_dir) then
      os.mkdir(archive_dir)
    end

    -- Hardcode the command name and parameters each format corresponds to
    if archive_format == "zip" then
      archive_command = "zip"
      archive_param = nil
    elseif archive_command == "tar" then
      archive_command = "tar"
      archive_param = "-cvf"
    end

    -- Concatnating archive_command/param/name into one string
    local archive_command = archive_command .. " "
    if archive_param then
      archive_command = archive_command .. archive_param .. " "
    end
    archive_command = archive_command .. archive_name

    -- Go into source directory and copy files to archive directory.
    os.cd(target:values("joj.source_dir"))
    for _, file in ipairs(target:values("joj.files")) do
      os.cp(file, archive_dir);
    end
    os.cd(archive_dir)
    -- Archive files
    os.execv(archive_command, target:values("joj.files"));
    for _, file in ipairs(target:values("joj.files")) do
      os.rm(file);
    end
  end)

  after_clean(function (target)

    -- If files that needed to be uploaded are not specified, issues an error.
    assert(target:values("joj.files") ~= nil, "joj.files must be specified, e.g. add_values(\"joj.files\", \"src/main.cpp\")")
    assert(target:values("joj.format") ~= nil, "joj.format must be specified, e.g. set_values(\"joj.format\", \"zip\") ")

    local archive_format = target:values("joj.format")
    local archive_name = target:name() .. "." .. archive_format
    local archive_dir = nil

    if not target:values("joj.archive_dir") then
      archive_dir = "upload"
    else
      archive_dir = target:values("joj.archive_dir")
    end

    -- Remove packed source files after `xmake clean $(target)`.
    if os.exists(archive_dir .. "/" .. archive_name) then
      os.rm(archive_dir .. "/" .. archive_name)
    end
  end)

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
  set_values("joj.archive_dir", "upload")

target("test")
  add_packages("conan::boost-ext-ut/1.1.8")
  set_kind("binary")
  set_languages("cxx20")
  add_files("src/*.cpp|main.cpp", "test/main.cpp")
  add_includedirs("src")

  -- Uncomment to generate coverage report.
  -- -- generate coverage report under coverage mode
  -- after_run(function (target)
  --   if is_mode("coverage") then
  --     os.execv("grcov", { ".", "-s", "src", "--binary-path", target:objectdir(), "-t", "html", "--branch", "--ignore-not-existing", "-o", "./coverage" })
  --   end
  -- end)
