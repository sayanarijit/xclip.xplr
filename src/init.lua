local function setup(args)
  local xplr = xplr

  args = args or {}
  args.copy_command = args.copy_command or "xclip-copyfile"
  args.copy_paths_command = args.copy_paths_command or "xclip -sel clip"
  args.paste_command = args.paste_command or "xclip-pastefile"
  args.keep_selection = args.keep_selection or false


  xplr.fn.custom.xclip_copy = function(app)
    local files = {}
    local count = 0
    local msgs = {}

    for i, node in ipairs(app.selection) do
      table.insert(files, node.absolute_path)
      count = i
    end

    if count == 0 and app.focused_node ~= nil then
      table.insert(files, app.focused_node.absolute_path)
      count = 1
    end

    if count == 0 then
      table.insert(msgs, { LogError = "No file to copy" })
    elseif count == 1 then
      os.execute(args.copy_command .. " '" .. files[1] .. "'")
      table.insert(msgs, { LogSuccess = "Copied " .. files[1] })
    else
      os.execute(args.copy_command .. " '" .. table.concat(files, "' '") .. "'")
      table.insert(msgs, { LogSuccess = "Copied " .. count .. " files." })
    end

    return msgs
  end

  xplr.config.modes.custom.xclip_copy = {
    name = "xclip copy",
    key_bindings = {
      on_key = {
        y = {
          help = "copy files",
          messages = {
            { CallLuaSilently = "custom.xclip_copy" },
            "PopMode",
          },
        },
        p = {
          help = "copy paths",
          messages = {
            {
              BashExecSilently = [===[
              if ]===] .. args.copy_paths_command .. [===[ < "${XPLR_PIPE_RESULT_OUT:?}"; then
                echo "LogSuccess: Copied path(s) to clipboard" >> "${XPLR_PIPE_MSG_IN:?}"
              else
                echo "LogError: Failed to copy path" >> "${XPLR_PIPE_MSG_IN:?}"
              fi
              ]===]
            },
            "PopMode",
          },
        },
        P = {
          help = "copy parent directory",
          messages = {
            {
              BashExecSilently = [===[
              if ]===] .. args.copy_paths_command .. [===[ <<< "${PWD:?}"; then
                echo "LogSuccess: Copied $PWD to clipboard" >> "${XPLR_PIPE_MSG_IN:?}"
              else
                echo "LogError: Failed to copy $PWD" >> "${XPLR_PIPE_MSG_IN:?}"
              fi
              ]===]
            },
            "PopMode",
          },
        },
        esc = {
          help = "cancel",
          messages = { "PopMode" },
        },
        ["ctrl-c"] = {
          help = "terminate",
          messages = { "Terminate" },
        }
      }
    }
  }

  if not args.keep_selection then
    table.insert(xplr.config.modes.custom.xclip_copy.key_bindings.on_key.y.messages, "ClearSelection")
    table.insert(xplr.config.modes.custom.xclip_copy.key_bindings.on_key.p.messages, "ClearSelection")
    table.insert(xplr.config.modes.custom.xclip_copy.key_bindings.on_key.P.messages, "ClearSelection")
  end


  xplr.config.modes.builtin.default.key_bindings.on_key.y = {
    help = "copy to clipboard",
    messages = {
      "PopMode",
      { SwitchModeCustom = "xclip_copy" }
    },
  }

  xplr.config.modes.builtin.default.key_bindings.on_key.p = {
    help = "paste from clipboard",
    messages = {
      { BashExecSilently = args.paste_command },
      "PopMode",
    },
  }
end

return { setup = setup }
