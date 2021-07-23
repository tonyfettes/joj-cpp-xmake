-- rules to package source files as an archive to be submitted on JOJ
rule("joj")
  on_package(function (target)

    -- If files that needed to be uploaded are not specified, issues an error.
    assert(target:values("joj.files") ~= nil,
      "joj.files must be specified, e.g. add_values(\"joj.files\", \"src/main.cpp\")")
    assert(target:values("joj.format") ~= nil,
      "joj.format must be specified, e.g. set_values(\"joj.format\", \"zip\")")

    local archive_format = target:values("joj.format")
    local archive_name = nil
    -- `joj.archive_filename_no_ext` is optional.
    if not target:values("joj.archive_filename_no_ext") then
      archive_name = target:name() .. "." .. archive_format
    else
      archive_name = target:values("joj.archive_filename_no_ext") .. "." .. archive_format
    end

    local source_dir = target:values("joj.source_dir") or "$(projectdir)"
    assert(os.exists(source_dir), "joj.source_dir does not exists")

    -- If archive directory does not exist, we make it.
    local archive_dir = target:values("joj.archive_dir") or "$(projectdir)/upload"
    if not os.exists(archive_dir) then
      os.mkdir(archive_dir)
    end

    -- Hardcode the command name and parameters each format corresponds to
    local archive_command = nil
    local archive_param = nil
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
    local archive_dir = target:values("joj.archive_dir") or "$(projectdir)/upload"

    -- Remove packed source files after `xmake clean $(target)`.
    if os.exists(archive_dir .. "/" .. archive_name) then
      os.rm(archive_dir .. "/" .. archive_name)
    end
  end)

task("submit")
  set_category("plugin")
  on_run(function ()
    import("core.project.project")
    for _, target in pairs(project.targets()) do
      if target:values("joj.files") ~= nil then
        local archive_format = target:values("joj.format")
        local archive_name = nil
        -- `joj.archive_filename_no_ext` is optional.
        if not target:values("joj.archive_filename_no_ext") then
          archive_name = target:name() .. "." .. archive_format
        else
          archive_name = target:values("joj.archive_filename_no_ext") .. "." .. archive_format
        end
        local archive_dir = target:values("joj.archive_dir") or "$(projectdir)/upload"
        archive_name = archive_dir .. "/" .. archive_name

        local problem_url = target:values("joj.problem_url")
        assert(os.exists(archive_name), "Archive " .. archive_name .. " not found.")
        assert(problem_url, "Problem URL not found in target settings")
        local joj_sid = target:values("joj.sid")
        if joj_sid ~= nil then
          os.setenv("JOJ_SID", joj_sid)
        end
        os.execv("joj-submit", { problem_url, archive_name, "cc" })
      end
    end
  end)
  set_menu {
    usage = "xmake submit",
    description = "Submit archive to JOJ",
  }
