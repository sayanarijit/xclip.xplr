local function setup(args)
  local xplr = xplr

  if args == nil then
    args = {}
  end

  if args.copy_command == nil then
    args.copy_command = "xclip-copyfile"
  end

  if args.paste_command == nil then
    args.paste_command = "xclip-pastefile"
  end

  if args.keep_selection == nil then
    args.keep_selection = false
  end


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

    if not args.keep_selection then
      table.insert(msgs, "ClearSelection")
    end

    return msgs
  end

  xplr.config.modes.custom.xclip_copy = {
    name = "xclip copy",
    key_bindings = {
      on_key = {
        y = {
          help = "copy",
          messages = {
            { CallLuaSilently = "custom.xclip_copy" },
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
