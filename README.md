# Sten's dotfiles (1.9.1)

This repository contains dotfiles and configuration scripts to set up my own development environment on a new machine. I'm currently using WSL so that's what this is mostly for. Feel free to use this yourself but use at your own risk.

## Setup

### Windows

If you're running this in WSL on Windows, you'll probably want to install an X server on Windows, e.g. Xming.

### Setup Script

To set up everything do either of the following.

- Run the following command which should handle everything:

```bash
bash -c "$(wget -qO - https://raw.github.com/sten626/dotfiles/master/src/os/setup.sh)"
```

- If you already have Git installed, you can just clone the repository and run `src/os/setup.sh`.

### What it Does

- Downloads all the files.
- Creates a workspace directory in your Windows User folder and a symlink to the workspace in your WSL `home`.
- Creates symlinks for all the `bash`, `git`, and `vim` files in your WSL `home`.
- Creates local config files for `bash` and `git`, to include personal information that shouldn't be stored in the repository.
- Installs various applications and command line tools.

### Local Config Files

#### `~/.bash.local`

The `~/.bash.local` file is sourced last and is a good place to store local aliases or `PATH` modifications.

#### `~/.gitconfig.local`

The `~/.gitconfig.local` is included by the regular `~/.gitconfig` file and is the ideal place to store sensitive or personal information such as your name or email address.

## Thanks

- [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles) was where I took most of the inspiration for this, as I really liked how his was set up.
- [Mathias Bynens](https://github.com/mathiasbynens) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles) as his seems to be incredibly popular and I took browsed it often as well.
