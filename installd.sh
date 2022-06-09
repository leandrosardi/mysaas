#
# installd.sh
#
# This script is to install your local development environment on Ubuntu 22.04.
# Reference: https://github.com/leandrosardi/mysaas/issues/16
#
#

echo 'update apt... '
sudo apt-get update

echo 'upgrade apt... '
sudo apt-get upgrade

echo 'install net tools... '
sudo apt-get install -y net-tools

echo 'install ssh server... '
sudo apt-get install -y openssh-server

echo 'add ssh to the firewall... '
sudo ufw allow ssh

echo 'install gnupg2... '
sudo apt-get install -y gnupg2

echo 'get RVM project’s public key... '
gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

echo 'move to the /tmp folder... '
cd /tmp

echo 'download the RVM installation script... '
curl -sSL https://get.rvm.io -o rvm.sh

echo 'install the latest stable version of Ruby and Rails... '
cat /tmp/rvm.sh | bash -s stable --rails

echo 'start RVM... '
source /usr/local/rvm/scripts/rvm

echo 'install Ruby 3.1.2... '
rvm install 3.1.2

echo 'set 3.1.2 as the defaut version of Ruby... '
rvm --default use 3.1.2

echo 'install git... '
sudo apt-get install -y git

echo 'install libpq-dev (PostgreSQL dev package)... '
sudo apt-get install -y libpq-dev