# Syno SMB macOS

This scripts adds some VFS Objects to Synology's `smb.conf` that improve compatibility with macOS, e. g. Final Cut Pro X (see <https://support.apple.com/en-us/HT207128>).

#### 1. Notes

- The script is able to automatically update itself using `git`.

#### 2. Installation

##### 2.1 Install via Git

###### a) Install Git (optional)

- install the package `Git Server` on your Synology NAS, make sure it is running (requires sometimes extra action in `Package Center` and `SSH` running)
- alternatively add SynoCommunity to `Package Center` and install the `Git` package ([https://synocommunity.com/](https://synocommunity.com/#easy-install))
- you can also use `entware` (<https://github.com/Entware/Entware>)

###### b) Install this script (using git)

- create a shared folder e. g. `sysadmin` (you want to restrict access to administrators and hide it in the network)
- connect via `ssh` to the NAS and execute the following commands

```bash
# navigate to the shared folder
cd /volume1/sysadmin
# clone the following repo
git clone https://github.com/alexanderharm/syno-smb-macos
# to enable autoupdate
touch syno-smb-macos/autoupdate
```

##### 2.2 Install this script (manually)

- create a shared folder e. g. `sysadmin` (you want to restrict access to administrators and hide it in the network)
- create a subfolder named `syno-smb-macos`
- copy your `synoSmbMacos.sh` to `sysadmin/syno-smb-macos` using e. g. `File Station` or `scp`
- make the script executable by connecting via `ssh` to the NAS and executing the following command

```bash
chmod 755 /volume1/sysadmin/syno-smb-macos/synoSmbMacos.sh
```

#### 3. Usage:

- create a new task in the `Task Scheduler`

```
# Type
Scheduled task > User-defined script

# General
Task:    synoSmbMacos
User:    root
Enabled: yes

# Schedule
Run on the following days: Daily
First run time:            00:00
Frequency:                 Every 30 minute(s)
Last run time:			   23:30

# Task Settings
Send run details by email:      yes
Email:                          (enter the appropriate address)
Send run details only when
  script terminates abnormally: yes
  
User-defined script: /volume1/sysadmin/syno-smb-macos/synoSmbMacos.sh
```
