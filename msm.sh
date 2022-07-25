#! /bin/bash

# --- GLOBAL VARS ---
# name of room, appended to MSMDIR
ROOM=${1:-"chat"}
# root directory of all chat rooms
MSMDIR="/mnt/batman/rooms/"

# sends close message & kills program. called from SIGINT
close_chat () {
	send_msg "$USER left room $ROOM"
	trap - SIGINT SIGTERM
	kill -- -$$
}

# sends formatted message to current room
send_msg () {
	echo -e "\r[$(date +'%H:%M')] $1" >> $MSMDIR$ROOM
}

# check if room directory exists. create if not
if [ ! -d $MSMDIR$ROOM ]
then
	sudo touch $MSMDIR$ROOM
	sudo chmod a+rw $MSMDIR$ROOM
fi

# open reading stream
tail -f $MSMDIR$ROOM &

# notify room of presence
send_msg "$USER entered room $ROOM"

# listen for SIGINT to close
trap close_chat SIGINT SIGTERM

# listen for and send chat messages
while :
do
	read line
	send_msg "$USER: $line"
done
