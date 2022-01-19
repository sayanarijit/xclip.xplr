[![copy.gif](https://s3.gifyu.com/images/copy.gif)](https://gifyu.com/image/tBwL)

Copy and paste with system clipboard using
[xclip](https://github.com/astrand/xclip).

## Requirements

- [xclip](https://github.com/astrand/xclip)

## Installation

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/xclip.xplr ~/.config/xplr/plugins/xclip
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("xclip").setup()

  -- Or

  require("xclip").setup{
    copy_command = "xclip-copyfile",
    copy_paths_command = "xclip -sel clip",
    paste_command = "xclip-pastefile",
    keep_selection = false,
  }

  -- Type `yy` to copy and `p` to paste whole files.
  -- Type `yp` to copy the paths of focused or selected files.
  -- Type `yP` to copy the parent directory path.
  ```
