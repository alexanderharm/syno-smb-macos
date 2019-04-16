#!/bin/bash

# check if run as root
if [ $(id -u "$(whoami)") -ne 0 ]; then
	echo "synoSmbMacos needs to run as root!"
	exit 1
fi

# check if git is available
if command -v /usr/bin/git > /dev/null; then
	git="/usr/bin/git"
elif command -v /usr/local/git/bin/git > /dev/null; then
	git="/usr/local/git/bin/git"
elif command -v /opt/bin/git > /dev/null; then
	git="/opt/bin/git"
else
	echo "Git not found therefore no autoupdate. Please install the official package \"Git Server\", SynoCommunity's \"git\" or Entware's."
	git=""
fi

# save today's date
today=$(date +'%Y/%m/%d')

# self update run once daily
if [ ! -z "${git}" ] && [ -d "$(dirname "$0")/.git" ] && [ -f "$(dirname "$0")/autoupdate" ]; then
	if [ ! -f /tmp/.synoSmbMacosUpdate ] || [ "${today}" != "$(date -r /tmp/.synoSmbMacosUpdate +'%Y-%m-%d')" ]; then
		echo "Checking for updates..."
		# touch file to indicate update has run once
		touch /tmp/.synoSmbMacosUpdate
		# change dir and update via git
		cd "$(dirname "$0")" || exit 1
		$git fetch
		commits=$($git rev-list HEAD...origin/master --count)
		if [ $commits -gt 0 ]; then
			echo "Found a new version, updating..."
			$git pull --force
			echo "Executing new version..."
			exec "$(pwd -P)/synoSmbMacos.sh" "$@"
			# In case executing new fails
			echo "Executing new version failed."
			exit 1
		fi
		echo "No updates available."
	else
		echo "Already checked for updates today."
	fi
fi

# Check if vfs objects exist
if ! grep -q 'vfs objects=catia,fruit,streams_xattr' "/etc/samba/smb.conf"; then
	echo "Modify smb.conf"
	if [ -n "$(tail -c 1 "/etc/samba/smb.conf")" ]; then
		echo '' >> "/etc/samba/smb.conf"
	fi
	echo '\tvfs objects=catia,fruit,streams_xattr' >> "/etc/samba/smb.conf"
	echo "Restart smbd"
	restart smbd
else
	echo "Config untouched."
fi

exit 0