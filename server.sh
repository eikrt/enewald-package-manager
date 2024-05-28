#!/bin/bash

PORT=8080

# Function to handle HTTP requests
handle_request() {
	local request
	IFS= read -r request
	echo "Request: $request"

	# Parse the request line
	read -r method path protocol <<<"$request"

	local FILE="sources$path"
	echo "File: $FILE"
	if [[ "$method" == "GET" ]]; then
		if [[ -f "$FILE" ]]; then
			# Send HTTP response header
			echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Disposition: attachment; filename=\"$FILE\"\r\n\r\n"
			# Send the file content
			cat "$FILE"
		else
			# Send 404 response if file not found
			echo -e "HTTP/1.1 404 Not Found\r\n\r\nFile not found"
		fi
	else
		# Send 404 response for any other path
		echo -e "HTTP/1.1 404 Not Found\r\n\r\nPath not found"
	fi
}

# Start the server
while true; do
	echo "Listening on port $PORT..."
	# Listen for incoming connections and handle requests
	{ echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello, World!\r\n" | nc -l -p $PORT -q 1; } | handle_request
done
