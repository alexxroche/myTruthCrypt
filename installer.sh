#!/bin/sh
# myTruthCrypt installer.sh ver. 20180317155824 Copyright 2018 alexx, MIT Licence

usage() {
 #sh <(curl -s https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/installer.sh)
 #sh <(wget -qO- https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/installer.sh)
	echo "# cut and paste the next 8 lines into a command line and it will install myTruthCrypt"|tr -d '\n';echo '
if $(which curl &>/dev/null);then
 curl -s https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/installer.sh|sudo sh
elif $(which wget &>/dev/null);then
 wget -qO- https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/installer.sh|sudo sh
else
 sudo apt-get install -y which wget curl debianutils 2>/dev/null || \
 sudo yum install -y wget curl which 2>/dev/null
fi
'
}

if [ "$1" ]&&[ "$1" = '-h' ]; then usage; exit; fi

PATH=$PATH:~/bin
if [ $(which myTruthCrypt) ]; then
	echo "Looks like myTruthCrypt is already installed in $(which myTruthCrypt) "
	exit 1
else
	[ "$HOME" ] && cd "$HOME" || cd ~
	mkdir bin 2>/dev/null
	cd bin
	wget https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/myTruthCrypt
	chmod 0700 myTruthCrypt
	sudo apt-get install -y bash sed util-linux cryptsetup e2fsprogs apg coreutils dmesg losetup awk argon2 tr sha1sum openssl 2>/dev/null || \
	sudo yum install -y coreutils bash sed openssl util-linux cryptsetup e2fsprogs argon2 tr sha1sum awk apg dmesg losetup 2>/dev/null
	cd
	echo "Your new passphrase is (make a note of it): $(apg -a 0 -n1 -m128 -M sNCL)"
	myTruthCrypt
fi

