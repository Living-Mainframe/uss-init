# USS Environment Setup Script

This is a shell script designed to set up a new Unix System Services (USS) environment on z/OS. The script is authored by Dorian Zimmer and licensed under the Apache License, Version 2.0.

## Features

- Create and tag a .bashrc file
- Add unicode u* aliases for common commands
- Add clear as an alias and as ^L
- Add common environment variables to .profile
- Enhance the shell prompt to show the current git branch of git managed directories

## Usage

To use this script, run it with one or more of the following commands as arguments:

```
$ ./uss-init.sh [commands]

```

## Available commands:

- bashrc: Create and tag ~/.bashrc
- aliases: Add unicode u* aliases
- clear: Add clear as an alias and as ^L
- exports: Add common environment variables to ~/.profile
- git: Enhance the shell prompt to show the current git branch of git managed directories

## You can chain multiple commands together, for example:

```
$ ./uss-init.sh bashrc aliases clear exports git

```

## Requirements

- bash shell installed on your system

