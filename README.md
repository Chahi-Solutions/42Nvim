# 42Nvim
### Most of 42 student prefer to use Neovim IDE, let's setup it now. 

Installation Guide
## Nvim 
- Extract nvim by using :
  ```bash
  tar -xvzf nvim-linux-x86_64.tar.gz 
- You will get : nvim-linux-x86_64
- Rename the file using :
  ```bash
  mv nvim-linux-x86_64 nvim
- Move the nvim to your home directory using :
  ```bash
  mv nvim ~
- Open the `.zshrc` and go the end of file and add : `export PATH=$PATH:$HOME/nvim/bin:` to the end of file.
- extract the nvim config folder after moving it to .config director : 
    ```bash
    tar -xzf nvim.tar.gz 

## Kitty 
- Install kitty terminal :
  ```bash
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
- Move kitty to home directorty :
  ```bash 
  mv ~/.local/kitty.app ~/kitty
- Add this line to `.zshrc` :
  ```bash
  export PATH=$PATH:$HOME/kitty/bin:
- Create the kitty config directory if it doesn’t exist :
  ```bash
  mkdir -p ~/.config/kitty
- Move the kitty.conf file to config directory :
    ```bash
  mv kitty.conf ~/.config/kitty/

- Make the kitty the main terminal and open it using the `ctrl + alt+ T` shortcut : 
- Open setting 
- Got to keyboard->View and Customize Shortcuts-> Scrole down -> Custom Shortcuts
- Click the `+` 
- `Name` : kitty terminal. 
- `Command`: /home/\[your user]/kitty/bin/kitty
- Click replace.
- remember use the shortcut to opent kitty.

                                                                            realized by achahi.
