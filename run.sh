#
# My box personal setup
# Do a basic setup of debian 10 and execute this script
#

if [ "$(id -u)" != "0" ]; then
  echo "You must run this script as root."
  exit
fi

#
# Remove deb-src, add contrib non-free and update system
#
sed -i "s/^deb-src/#&/g" /etc/apt/sources.list
sed -i 's/^deb http:\/\/deb.debian.org\/debian\/ buster main$/deb http:\/\/deb.debian.org\/debian\/ buster main contrib non-free/' /etc/apt/sources.list

#
# Upgrade System
#
apt-get	update ; apt-get -y dist-upgrade

#
# Install basic packages
#
apt-get install -y apt-transport-https net-tools ssh sshfs git screen bzip2 curl wget rsync sudo

#
# Install Visual Studio Code
#
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt-get update
apt-get install -y code

#
# Install Skype
#
wget https://repo.skype.com/latest/skypeforlinux-64.deb -P /tmp
dpkg -i /tmp/skypeforlinux-64.deb
apt-get install -f -y

#
# Install Discord
#
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
dpkg -i /tmp/discord.deb
apt-get install -f -y

#
# Install nodejs 10.x
#
wget -qO- https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y nodejs


#
# Work In Progress...
#