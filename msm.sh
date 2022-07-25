#! /bin/bash

CHATDIR=${1:-"chat"}
MSMDIR="$HOME"

close_chat () {
	send_msg "$USER left room $CHATDIR"
	trap - SIGINT SIGTERM
	kill -- -$$
}

send_msg () {
	echo -e "\r[$(date +'%H:%M')] $1" >> $MSMDIR/$CHATDIR
}

tail -f $MSMDIR/$CHATDIR &

send_msg "$USER entered room $CHATDIR"

trap close_chat SIGINT SIGTERM

while :
do
	read line
	send_msg "$USER: $line"
done
