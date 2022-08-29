# Sten's dotfiles

This repository contains dotfiles and configuration scripts to set up my own development environment on a new machine. I'm currently using WSL and various Linux machines so that's what this is mostly for. Feel free to use this yourself but use at your own risk.

## Setup

### Setup Script

To set up everything do the following.

- Install git.
- Clone the repository:

```bash
git clone https://github.com/sten626/dotfiles.git
```

- Run the install script in the root directory, `./install.sh`.

Note: I may add back a standalone install script that doesn't require git to be preinstalled at some point but not right now.

### What it Does

- Creates symlinks for all the dotfiles in the `bash` directory in your user home directory.
- Creates local config files for `bash` and `git`, to include personal information that shouldn't be stored in the repository.
- Installs various applications and command line tools.

### Local Config Files

#### `~/.bash.local`

The `~/.bash.local` file is sourced last and is a good place to store local aliases or `PATH` modifications.

#### `~/.gitconfig.local`

The `~/.gitconfig.local` is included by the regular `~/.gitconfig` file and is the ideal place to store sensitive or personal information such as your name or email address.

## `bin/` Scripts

Some utility scripts I like to use.

### `branchexists`

Checks if a given branch name exists in the current repository. Could easily be a bash function, but made it a script to more easily incorporate into other scripts.

### `switchto`

Script for easily changing branches in a git repository. I've tried to make it fairly agnostic and extendible.

#### `switchto_findbranch`

If a script with this name exists in your `PATH`, `switchto` will use it to try and resolve a number argument into a branch name. By default it only looks for `issue-NUM`

#### `switchto_install`

If a script with this name exists in your `PATH`, `switchto` will use it to install/compile after switching branches. By default it will only run `npm install` or `make` depending on what files it sees in the project root.

## Thanks

- [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles) was where I took most of the inspiration for this, as I really liked how his was set up.
- [Mathias Bynens](https://github.com/mathiasbynens) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles) as his seems to be incredibly popular and I took browsed it often as well.
