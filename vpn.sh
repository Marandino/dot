#!/bin/bash

# Configuration path (Replace it with the actual path to your ovpn file).
CONFIG_PATH="/home/user/foo.ovpn"

# Function to manage the OpenVPN session
manage_session() {

    # Display options to user
    echo "Choose an option:"
    echo "s) Start a new session"
    echo "d) Disconnect all active connections"
    # echo "p) Pause"
    # echo "r) Restart"
    # echo "m) Resume"
    echo "l) List sessions"
    echo "q) Quit"

    read -n1 -p "Enter your choice: " choice
    echo

    # Switch case for user's choices
    case "$choice" in
	    [Ss])
		    echo "Starting a new session..."
		    # Workaround just because my system is unable to open the URL automatically
		    # Stores the URL
		    URL=$(openvpn3 session-start --config $CONFIG_PATH | grep -o 'http[s]\?://\S*')
		    if [ -n "$URL" ]; then
			    # use xdg-open to open the URL
			    xdg-open $URL >/dev/null 2>&1
		    fi
		    ;;
	    [Dd])
		    echo "Disconnecting all active sessions..."
		    for session_path in $(openvpn3 sessions-list | grep "Path" | awk '{print $2}'); do
			    openvpn3 session-manage --session-path $session_path --disconnect
		    done
		    ;;

	    # [Pp])
		    #     echo "Pausing..."
		    #     openvpn3 session-manage --pause --config $CONFIG_PATH
		    #     ;;

	    # [Rr])
		    #     echo "Restarting..."
		    #     openvpn3 session-manage --restart --config $CONFIG_PATH
		    #     ;;

	    # [Mm])
		    #     echo "Resuming..."
		    #     openvpn3 session-manage --resume --config $CONFIG_PATH
		    #     ;;

	    [Ll])
		    echo "Listing sessions..."
		    openvpn3 sessions-list
		    ;;

	    [Qq])
		    echo "Exiting..."
		    exit 0
		    ;;

	    *)
		    echo "Invalid option. Please try again."
		    ;;
    esac
}

while true; do
	manage_session
done
