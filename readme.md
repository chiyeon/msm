# msm

An experimental chat using SSH

## How to Run

```console
./msm.sh
```

Then, type to chat.

## Installation
Prerequisites:
- shc

Simply run the `install.sh` script. Sudo privileges are required to move the compiled binary to `/usr/local/bin/`, where msm can be called from anywhere.

## Usage
To view the usage menu
```console
msm -h
```

msm has numerous optional flags.
- `-r <room>`: Specify a room to enter. Creates room in MSM directory if it doesn't exist. Default is 'chat'.
  
  Ex: `msm -r newroom`
- `-d <dir>`: Changes the MSM directory to `<dir>`. Can also be edited in the config file.

  Ex: `msm -d ~/work-chats/`
- `-h`: Prints the help menu
- `-v` Prints the current version
- `c` Resets the config file to defaults.

msm's config file can be found at $HOME/.config/msm/msm.config.
