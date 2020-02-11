# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.9.0] - 2020-02-11

### Added

- Adding `ghost-cli` to installed packages.

### Fixed

- Permissions issue on `os` scripts.

## [v1.8.0] - 2020-02-10

### Added

- Support for differences between WSL and normal Ubuntu.
- The word "Terminal" to the window title, for app switcher purposes.

## [v1.7.0] - 2019-12-23

### Added

- `switch_to` script for easily changing branches.
- Adding `ts-node` to installed packages.

## [v1.6.0] - 2019-11-24

### Added

- Added shellcheck to project and resolved warnings.
- Adding `meld` to installed tools.

### Fixed

- Resolving symbolic links to source files before creating symbolic links to them.

## [v1.5.0] - 2019-11-20

### Added

- New alias `nu` for updating node.
- New git aliases for bisecting.
- New apps added to installation:
  - `traceroute`
  - `unzip`
  - `whois`
- Adding `npm-merge-driver`.

## [v1.4.0] - 2019-08-05

### Added

- Git alias for `commit`.

## [v1.3.1] - 2019-07-27

### Fixed

- Sourcing `bash_profile` should no longer give errors when launching in a non-Windows+WSL directory.

## [v1.3.0] - 2019-07-22

### Added

- Information about relation to upstream in the prompt's git info.
- Moving from Windows user home to WSL home when starting a new terminal.

## [v1.2.1] - 2019-07-22

### Fixed

- Removed debugging statements from SSH agent setup.

## [v1.2.0] - 2019-07-21

### Added

- A few minor things from my old `.bashrc` that I hadn't ported over yet.
- Some `git` aliases for merging.

### Changed

- Changes to colours used by `ls`; adding a dircolors file.

## [v1.1.0] - 2019-07-18

### Added

- SSH agent launching for WSL.

## [v1.0.2] - 2019-07-18

### Fixed

- Fixing ugly highlighting on directories when using `ls`.

## [v1.0.1] - 2019-07-14

### Fixed

- Fixing various issues with running the setup script independently.

## [v1.0.0] - 2019-07-13

- Initial release

[Unreleased]: https://github.com/sten626/dotfiles/compare/v1.9.0...develop
[v1.9.0]: https://github.com/sten626/dotfiles/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/sten626/dotfiles/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/sten626/dotfiles/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/sten626/dotfiles/compare/v1.5.0...v1.6.0
[v1.5.0]: https://github.com/sten626/dotfiles/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/sten626/dotfiles/compare/v1.3.1...v1.4.0
[v1.3.1]: https://github.com/sten626/dotfiles/compare/v1.3.0...v1.3.1
[v1.3.0]: https://github.com/sten626/dotfiles/compare/v1.2.1...v1.3.0
[v1.2.1]: https://github.com/sten626/dotfiles/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/sten626/dotfiles/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/sten626/dotfiles/compare/v1.0.2...v1.1.0
[v1.0.2]: https://github.com/sten626/dotfiles/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/sten626/dotfiles/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/sten626/dotfiles/releases/tag/v1.0.0
