#!/bin/sh

REMOTE='http://localhost:8000'
ENEWALD_LOCATION="/etc/enewald"

setup() {
	local param=$1
	sudo mkdir -p $ENEWALD_LOCATION
	sudo mkdir -p $ENEWALD_LOCATION/sources.local
	sudo mkdir -p $ENEWALD_LOCATION/binaries.local
	sudo chown -R $USER $ENEWALD_LOCATION
}

preinstall() {
	local resource=$1
	echo "Preinstalling $resource..."
	Metadata=$(cat "$ENEWALD_LOCATION/sources.local/$resource/Metadata")
	eval $Metadata
	echo $Name
	tar -xvf $ENEWALD_LOCATION/sources.local/$resource/$Name.$Format -C $ENEWALD_LOCATION/sources.local/$resource
	cd $ENEWALD_LOCATION/sources.local/$resource/$Name
	./configure
}
install() {
	local target="$1"
	Metadata=$(cat "$ENEWALD_LOCATION/sources.local/$target/Metadata")
	eval $Metadata
	echo "Installing ${target}..."
	make -C "$ENEWALD_LOCATION/sources.local/$target/$Name"
	echo "${target} dependencies installed."
}

build() {
	local target="$1"
	echo "Building ${target}..."
	echo "${target} project built successfully."
}

fetch() {
	local resource="$1"
	echo "Fetching ${resource}..."
	mkdir -p "$ENEWALD_LOCATION/sources.local/$resource"
	wget -P "$ENEWALD_LOCATION/sources.local/$resource" -q "$REMOTE/sources.server/$resource/Metadata"
	Metadata=$(cat "$ENEWALD_LOCATION/sources.local/$resource/metadata")
	echo "Fetched Metadata: $Metadata"
	eval $Metadata
	wget -P "$ENEWALD_LOCATION/sources.local/$resource" $REMOTE/sources.server/$resource/$Name.$Format
	echo "${resource} fetched."
}

remove() {
	local resource="$1"
	echo "Removing ${resource}..."
	rm -r "$ENEWALD_LOCATION/sources.local/$resource"
	echo "Done removing ${resource}!"
}
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 {preinstall|install|build|fetch} <target|resource>"
	exit 1
fi

command="$1"
target="$2"

case "$command" in
install)
	install "$target"
	;;
preinstall)
	preinstall "$target"
	;;
remove)
	remove "$target"
	;;
build)
	build "$target"
	;;
fetch)
	fetch "$target"
	;;
setup)
	setup "$target"
	;;
*)
	echo "Invalid option: $command"
	echo "Usage: $0 {install|build|fetch} <target|resource>"
	exit 1
	;;
esac