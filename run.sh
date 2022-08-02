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
sed -i 's/^deb http:\/\/deb.debian.org\/debian\/ bullseye main$/deb http:\/\/deb.debian.org\/debian\/ bullseye main contrib non-free/' /etc/apt/sources.list

#
# Upgrade System
#
apt-get	update ; apt-get -y dist-upgrade

#
# Install basic packages
#
apt-get install -y apt-transport-https software-properties-common net-tools ssh sshfs git screen bzip2 curl wget rsync zsh htop

#
# Install and confugure sudo
#
apt-get install -y sudo
echo "$SYSTEM_USER   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#
# Install i3wm Window Manager
#
apt-get install -y i3 xorg xterm nvidia-driver

#
# Install & configure oh-my-zsh (change default shell to zsh, and then exit to continue installation)
#
apt update ; apt-get -y install zsh
sudo -u $SYSTEM_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u $SYSTEM_USER sed -i 's/^ZSH_THEME="robbyrussell"$/ZSH_THEME="amuse"/' /home/$SYSTEM_USER/.zshrc
apt-get install fonts-powerline
# TODO: Add a more elegance zsh theme
# sudo -u $SYSTEM_USER sed -i 's/^ZSH_THEME="robbyrussell"$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/$SYSTEM_USER/.zshrc
# git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /home/$SYSTEM_USER/nerd-fonts
# ./home/$SYSTEM_USER/nerd-fonts/install.sh
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$SYSTEM_USER/.oh-my-zsh/custom/themes/powerlevel10k
# chsh -s $(which zsh) $SYSTEM_USER
# chsh -s $(which zsh)


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
# Configure Xresources
#
printf -- "
XTerm*faceName: DejaVu Sans Mono for Powerline
#xterm*faceName: Terminus
xterm*faceSize: 12
xterm*renderFont: true
" > /home/$SYSTEM_USER/.Xresources
chown $SYSTEM_USER.$SYSTEM_USER /home/$SYSTEM_USER/.Xresources

#
# Configure i3wm (has bug, must run under x enviroment)
#
sudo -u sysop i3-config-wizard -m win
sed -i 's/i3-sensible-terminal/xterm/' /home/$SYSTEM_USER/.config/i3/config

#
# Install various tools
#
apt-get install -y pulseaudio pavucontrol wireless-tools feh

#
# Install Chromium browser
#
apt-get install -y chromium

#
# Install Brave browser
#
apt install -y gnupg2
wget -qO- https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
apt update ; apt install -y brave-browser

#
# Install Opera browser
#
apt-get install -y gnupg2
wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/opera-archive-keyring.gpg >/dev/null
echo "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free" | tee /etc/apt/sources.list.d/opera.list >/dev/null
apt-get update ; apt-get install -y opera-stable
rm -rf /etc/apt/sources.list.d/opera.list # sorry bro

#
# Install Visual Studio Code
#
apt-get install -y gnupg2
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/vscode-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list >/dev/null
apt-get update ; apt-get install -y code

#
# Install Sublime Text Editor
#
apt-get install -y gnupg2
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublime-archive-keyring.gpg >/dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list >/dev/null
apt-get update ; apt-get install -y sublime-text

#
# Install Skype
#
apt-get install -y gnupg2
wget https://repo.skype.com/latest/skypeforlinux-64.deb -P /tmp
dpkg -i /tmp/skypeforlinux-64.deb
apt-get install -f -y

#
# Install Discord (TMPFIX: for debian 11)
#
wget "https://discordapp.com/api/download?platform=linux&format=deb" -O /tmp/discord.deb
dpkg -i /tmp/discord.deb
apt-get install -f -y

#
# Install current LTS nodejs
#
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
apt-get update
apt-get -y install nodejs

#
# Install composer.phar
#
apt-get install -y php-cli php-curl php-zip
wget "https://getcomposer.org/installer" -O /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/bin --filename=composer --quiet

#
# Install Docker CE
#
apt-get install -y gnupg2
wget -qO- https://download.docker.com/linux/debian/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg >/dev/null
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update ; apt-get install -y docker-ce
usermod -aG docker $SYSTEM_USER

#
# Install docker-composer
#
wget "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -O /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#
# Install MongoDB Compass Community Edition
#
wget "https://downloads.mongodb.com/compass/mongodb-compass_1.30.1_amd64.deb" -P /tmp
dpkg -i /tmp/mongodb-compass_1.30.1_amd64.deb

#
# Install php-cli & composer.phar
#
apt-get install -y php-cli
wget "https://getcomposer.org/installer" -O /tmp/composer-setup.php
php /tmp/composer-setup.php --install-dir=/bin --filename=composer --quiet

#
# Install DBeaver
#
wget -qO- https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/dbeaver-archive-keyring.gpg >/dev/null
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list >/dev/null
apt-get update ; apt-get install -y dbeaver-ce

#
# Install Real VNC Viewer
#
wget "https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.21.1109-Linux-x64.deb" -P /tmp
dpkg -i /tmp/VNC-Viewer-6.21.1109-Linux-x64.deb

#
# Install Oracle VirtualBox
#
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | gpg --dearmor | tee /etc/apt/trusted.gpg.d/oracle_vbox_2016-archive-keyring.gpg >/dev/null
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | gpg --dearmor | tee /etc/apt/trusted.gpg.d/oracle_vbox-archive-keyring.gpg >/dev/null
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bullseye contrib" | tee /etc/apt/sources.list.d/virtualbox.list >/dev/null
apt-get update ; apt-get install -y virtualbox-6.1

#
# Install Postman
#
wget "https://dl.pstmn.io/download/latest/linux64" -O /tmp/postman.tar.gz
tar -xzf /tmp/postman.tar.gz -C /opt/
sudo ln -s /opt/Postman/Postman /usr/local/bin/postman

#
# Work In Progress...
#
