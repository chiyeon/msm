#!/bin/bash

# --- GLOBAL VARS ---
# name of room, appended to MSMDIR
ROOM="chat"
VERSION="1.0"
NUM_LINES=50

# --- GLOBAL FUNCS ---
# prints usage
usage () {
	cat << EOF >&2
Usage: msm [-r <room>] [-w <room>] [-l <lines>] [-d <new dir>] [-v] [-h] [-c] 

Note: All users who wish to chat in a particular room MUST have read/write priviledges to that file. It is recommended to have all users be able to read/write a safe MSM directory.

The following flags are ALL OPTIONAL.

 -r <room>: Specify a room to enter. Creates room in MSM directory if it doesn't exist. Default is 'chat'.
 -w <room>: Specify a room to wipe. Deletes room and all chat history.
-l <lines>: Changes the number of lines to output in chat. Can also be edited in the config file.
  -d <dir>: Changes the MSM directory to <dir>. Can also be edited in the config file.
        -h: Prints this help text.
        -v: Prints the current MSM version.
        -c: Resets the MSM config file ($HOME/.config/msm/msm.config).

EOF
	exit 1
}

# Sends close message & kills program. Triggered by SIGINT.
close_chat () {
  send_msg_raw "[$(date +'%b %d, %Y %H:%M')] $USER left room $ROOM"
	trap - SIGINT SIGTERM
	kill -- -$$
}

# Sends message formatted with the date to the current room.
send_msg () {
	echo -e "[$(date +'%H:%M')] $@" >> $MSMDIR$ROOM
}

# sends message without formatting
send_msg_raw () {
  echo -e $@ >> $MSMDIR$ROOM
}

# Load config and create room if needed.
setup () {
	load_config

	# check if room directory exists. create if not
	if [ ! -d $MSMDIR$ROOM ]
	then
		# create file
		touch $MSMDIR$ROOM
	fi
}

# Opens chat & starts sending/recieving.
start_chat () {
	# Run setup function
	setup

	# clear screen
	clear

	# open reading stream
	# subtract 1 because user joining will add 1 line
	tail -n $(($NUM_LINES-1)) -f $MSMDIR$ROOM &
	tail_pid=$!

	# notify room of presence
  send_msg_raw "[$(date +'%b %d, %Y %H:%M')] $USER entered room $ROOM"

	# listen for SIGINT to close
	trap close_chat SIGINT SIGTERM

	# listen for and send chat messages
	while :
	do
		read line					# read message
		kill $tail_pid				# stop stream of messages
		clear						# clear screen (get rid of user input)
		send_msg "$USER: $line"		# append input to file
		tail -n $NUM_LINES -f $MSMDIR$ROOM &		# re open stream
		tail_pid=$!
	done
}

# Creates the default configuration file & directories.
create_default_config () {
	mkdir $HOME/.config/msm
	mkdir $HOME/chats
	echo "MSMDIR=$HOME/chats/" > $HOME/.config/msm/msm.config
	echo "NUM_LINES=50" >> $HOME/.config/msm/msm.config
	echo "MSM Config file created at $HOME/.config/msm/msm.config"
}

# Attempts to load the config file, creating it with defaults if it doesn't exist.
# Also validates config file contents & directories.
load_config () {
	# on startup check if our config file exists.
	if [ ! -f $HOME/.config/msm/msm.config ]; then
		# create file with default params
		echo "MSM First Time Startup. Generating config file..."
		create_default_config
	else
		# if exists, validate then load config
		. $HOME/.config/msm/msm.config

		# ensure last character of directory is '/'
		if [ "${MSMDIR: -1}" != "/" ]; then
			echo "Config Error: MSMDIR should end with a '/'!"
			exit 2
		fi
		# --- other validations would be here ---
	fi

	# also check if main directory exists
	if [ ! -d $MSMDIR ]; then
		echo "MSMDIR doesn't exist! Check msm.config or replace it with setdir."
		exit 2
	fi
}

# On startup, check for arguments.
while getopts r:w:l:d:vhc o; do
	case $o in
		(r)		# Set room & continue to open chat
			ROOM=$OPTARG
			;;
		(w)		# Delete a room
			load_config
			rm $MSMDIR$OPTARG
			echo "Removed room $OPTARG"
			exit 0
			;;
		(l)		# Lines to display
			sed -i -e "s~.*NUM_LINES.*~NUM_LINES=$OPTARG~" $HOME/.config/msm/msm.config
			echo "Changed NUM_LINES in msm.config to $OPTARG."
			load_config
			exit 0
			;;
		(d)		# Change MSM directory & close
			sed -i -e "s~.*MSMDIR.*~MSMDIR=$OPTARG~" $HOME/.config/msm/msm.config
			echo "Changed MSMDIR in msm.config to $OPTARG."
			load_config
			exit 0
			;;
		(v)		# Print version & close
			echo "MSM $VERSION"
			exit 0
			;;
		(h)		# Print usage & close
			usage
			;;
		(c)		# Reset config & close
			create_default_config
			exit 0
			;;
		(*)		# Print usage & close
			usage
			;;
	esac
done

# If pipe exists on stdin, write data to chat file.
if [ -p /dev/stdin ]; then
	# Run setup function
	setup	

	while IFS= read -r line; do
		send_msg "$USER: $line"
	done
else
	# If continued to this point, start chat in current room & MSM directory
	start_chat
fi
