# msm

An experimental chat using SSH

msm aims to provide a simple way to chat with other users conneced to the same SSH machine.

## How to Run

```console
./msm.sh

or if installed

msm
```

Then, type to chat.

## Installation

Run the `install.sh` script. Using `shc`, the script will compile the msm binary and place it in `bin/`. Sudo privileges are required to further copy it to `/usr/local/bin/`, where msm can be called from anywhere.

### Prerequisites
Prerequisites are **only required for installation!** If running as a bash script, nothing else is needed!

- shc

## Usage

To view the usage menu

```console
msm -h
```

### Flags

msm has numerous optional flags.

- `-r <room>`: Specify a room to enter. Creates room in MSM directory if it doesn't exist. Default is 'chat'.

  Ex: `msm -r newroom`

- `-d <dir>`: Changes the msm directory to `<dir>`. Can also be edited in the config file.

  Ex: `msm -d /mnt/batman/rooms/`

- `-l <lines>`: Changes the number of lines to display to `<lines>`. The default is 50 lines. Can also be edited in the config file.

  Ex: `msm -l 10`
  
- `-h`: Prints the help menu
- `-v` Prints the current version
- `-c` Resets the config file to defaults.

### Chat Directory

By default, the chat directory is `$HOME/chats/`. Any rooms will be created and edited here, so the location must be accessible for read and write by anyone who wishes to chat. It is **highly recommended** to not use a user home directory, as all users chatting require read and write permissions for files inside the directory.

### Rooms

Rooms are empty files created in the msm directory. The default room is `chat`. Messages are sent and recieved through editing and reading the text content of these files. Users' arrival/departure is automatically announced in the room.

### Config File

msm's config file can be found at `$HOME/.config/msm/msm.config`. If anything in the config breaks or flags like `-d` and `-l` do not work, it is recommended to reset the file to its default values with `msm -c`.
