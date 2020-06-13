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
apt-get install -y apt-transport-https software-properties-common net-tools ssh sshfs git screen bzip2 curl wget rsync sudo

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
# Install Docker CE
#
apt-get install gnupg2
wget -qO- https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
# Configure sysop user to use docker TODO: ask for username
usermod -aG docker sysop

#
# Install docker-composer
#
wget "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#
# Install MongoDB Compass Community Edition
#
wget "https://downloads.mongodb.com/compass/mongodb-compass-community_1.21.2_amd64.deb" -P /tmp
dpkg -i /tmp/mongodb-compass-community_1.21.2_amd64.deb


#
# Install steam
#
apt-get install -y bublebee
wget "https://repo.steampowered.com/steam/archive/precise/steam_latest.deb" -P /tmp
dpkg -i /tmp/steam_latest.deb
apt-get install -f -y

#
# Work In Progress...
#