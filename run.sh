#
# My box personal setup
# Do a basic setup of debian 10 and execute this script
#

if [ "$(id -u)" != "0" ]; then
  echo "You must run this script as root."
  exit
fi

SYSTEM_USER=sysop

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
apt-get install -y apt-transport-https software-properties-common net-tools ssh sshfs git screen bzip2 curl wget rsync

#
# Install and confugure sudo
#
apt-get install -y sudo
echo "$SYSTEM_USER   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#
# Install i3wm Window Manager
#
apt-get install -y i3 xorg xterm

#
# Configure keyboard language
#
printf -- "XKBMODEL=pc105
XKBLAYOUT=us,gr
XKBVARIANT=
#XKBOPTIONS=grp:ctrls_toggle
XKBOPTIONS=grp:alt_shift_toggle
BACKSPACE=guess
" > /etc/default/keyboard

#
# Install various wm tools
#
apt-get install -y alsa-utils wireless-tools feh

#
# Install chromium browser
#
apt-get install -y chromium

#
# Install Opera browser
#
apt-get install -y gnupg2
wget -qO- https://deb.opera.com/archive.key | apt-key add -
echo "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera.list
apt-get update && apt-get install -y opera-stable

#
# Install Visual Studio Code
#
apt-get install -y gnupg2
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt-get update && apt-get install -y code

#
# Install Sublime Text Editor
#
apt-get install -y gnupg2
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt-get update && apt-get install -y sublime-text

#
# Install Skype
#
apt-get install -y gnupg2
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
apt-get install -y gnupg2
wget -qO- https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce
# Configure sysop user to use docker TODO: ask for username
usermod -aG docker $SYSTEM_USER

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
dpkg --add-architecture i386
apt update && apt install -y libgl1-nvidia-glx:i386


#
# Install php-cli & composer.phar
#
apt-get install -y php-cli
wget "https://getcomposer.org/installer" -O /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/bin --filename=composer --quiet

#
# Install DBeaver
#
wget -qO- https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list
apt-get update && apt-get install -y dbeaver-ce

#
# Work In Progress...
#
