[![copy.gif](https://s3.gifyu.com/images/copy.gif)](https://gifyu.com/image/tBwL)

Copy and paste with system clipboard using
[xclip](https://github.com/astrand/xclip).

Requirements
------------

- [xclip](https://github.com/astrand/xclip)


Installation
------------

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  package.path = os.getenv("HOME") .. '/.config/xplr/plugins/?/src/init.lua'
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
    paste_command = "xclip-pastefile",
    keep_selection = false,
  }

  -- Type `yy` and copy and `p` to paste.
  ```
