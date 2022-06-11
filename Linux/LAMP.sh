#!/usr/bin/env bash


echo "##############################"
echo "#### RSYNC OF SOURCE CODE ####"
echo "##############################"
mkdir -p /var/www/html/bin

# update
echo "########################"
echo "##### UPDATING APT #####"
echo "########################"
apt-get update
apt-get install apt-utils

# Install Apache
echo "#############################"
echo "##### INSTALLING APACHE #####"
echo "#############################"
apt-get -y install apache2


echo "###############################"
echo "##### INSTALLING RABBITMQ #####"
echo "###############################"
#apt-get -y install rabbitmq-server

# Creating folder
echo "#######################################"
echo "##### MAGENTO2 FOLDER PERMISSIONS #####"
echo "#######################################"
chmod 0777 -R /var/www/html

# enable modrewrite
echo "#######################################"
echo "##### ENABLING APACHE MOD-REWRITE #####"
echo "#######################################"
a2enmod rewrite

# append AllowOverride to Apache Config File
echo "#######################################"
echo "##### CREATING APACHE CONFIG FILE #####"
echo "#######################################"
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
		ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
		<Directory '/var/www/html'>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride All
			Order allow,deny
			allow from all
		</Directory>
</VirtualHost>
" > /etc/apache2/sites-available/magento2.conf

echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 dev.magento2.com" >> /etc/hosts


# Enabling Site
echo "##################################"
echo "##### Enabling Magento2 Site #####"
echo "##################################"
a2ensite magento2.conf
a2dissite 000-default.conf
service apache2 restart
service apache2 status

# Setting Locales
echo "###########################"
echo "##### Setting Locales #####"
echo "###########################"
locale-gen en_US en_US.UTF-8 pl_PL pl_PL.UTF-8
# Piping output to file to avoid breaking shell through bad escape characters.
dpkg-reconfigure locales > /tmp/ignoreme

# Install MySQL 5.6
echo "############################"
echo "##### INSTALLING MYSQL #####"
echo "############################"
export DEBIAN_FRONTEND=noninteractive
apt-get install software-properties-common
apt-get -q -y install mysql-server mysql-client

service mysql start

# Create Database instance
echo "#############################"
echo "##### CREATING DATABASE #####"
echo "#############################"
mysql -u root -e "create database magento;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"

echo "##############################"
echo "##### INSTALLING PHP 7.1 #####"
echo "##############################"
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get -y update
apt-get -y install php7.1

# Install Required PHP extensions
echo "#####################################"
echo "##### INSTALLING PHP EXTENSIONS #####"
echo "#####################################"

apt-get update
apt-get -y install php7.1-mcrypt php7.1-curl php7.1-bcmath php7.1-soap php7.1-cli php7.1-mysql php7.1-gd php7.1-intl php7.1-common php7.1-dev php7.1-xsl php7.1-xml php7.1-mbstring php7.1-zip php-pear

service apache2 restart

# Set PHP Timezone
echo "########################"
echo "##### PHP TIMEZONE #####"
echo "########################"
echo "date.timezone = America/New_York" >> /etc/php/7.1/cli/php.ini

# Set Pecl php_ini location
echo "##########################"
echo "##### CONFIGURE PECL #####"
echo "##########################"
pear config-set php_ini /etc/php/7.1/apache2/php.ini

# Install Xdebug
echo "##########################"
echo "##### INSTALL XDEBUG #####"
echo "##########################"
pecl install xdebug

# Install Pecl Config variables
echo "############################"
echo "##### CONFIGURE XDEBUG #####"
echo "############################"
echo "xdebug.remote_enable = 1" >> /etc/php/7.1/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.1/apache2/php.ini

# Install Git
echo "##########################"
echo "##### INSTALLING GIT #####"
echo "##########################"
apt-get update
apt-get -y install git

echo "######################################"
echo "##### INSTALLING SYNCING SCRIPTS #####"
echo "######################################"
apt-get update
apt-get install -y inotify-tools
apt-get  install -y curl dos2unix lsyncd

# #LOG SYNCING
# cp /vagrant/vagrant/logsync.sh /root/logsync.sh
# chmod +x /root/logsync.sh
# dos2unix /root/logsync.sh

# cp /vagrant/vagrant/logsync /etc/init.d/logsync
# chmod +x /etc/init.d/logsync
# dos2unix /etc/init.d/logsync
# update-rc.d logsync defaults
# /etc/init.d/logsync start

# #STATIC SYNCING
# cp /vagrant/vagrant/staticsync.lua /root/staticsync.lua
# chmod +x /root/staticsync.lua
# dos2unix /root/staticsync.lua

# cp /vagrant/vagrant/staticsync.sh /root/staticsync.sh
# chmod +x /root/staticsync.sh
# dos2unix /root/staticsync.sh

# cp /vagrant/vagrant/staticsync /etc/init.d/staticsync
# chmod +x /etc/init.d/staticsync
# dos2unix /etc/init.d/staticsync
# update-rc.d staticsync defaults

# #GENERATED SYNCING
# cp /vagrant/vagrant/gensync.lua /root/gensync.lua
# chmod +x /root/gensync.lua
# dos2unix /root/gensync.lua

# cp /vagrant/vagrant/gensync.sh /root/gensync.sh
# chmod +x /root/gensync.sh
# dos2unix /root/gensync.sh

# cp /vagrant/vagrant/gensync /etc/init.d/gensync
# chmod +x /etc/init.d/gensync
# dos2unix /etc/init.d/gensync
# update-rc.d gensync defaults

# NOTE: NOT STARTING IT NOW. WILL START AT THE END

echo "###############################"
echo "##### INSTALLING COMPOSER #####"
echo "###############################"
apt-get install curl
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Set Ownership and Permissions
echo "#############################################"
echo "##### SETTING OWNERSHIP AND PERMISSIONS #####"
echo "#############################################"
chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 770 {} \;
find /var/www/html/ -type f -exec chmod 660 {} \;
# Add vagrant user to www-data group
usermod -a -G www-data vagrant

echo "##################################"
echo "##### Installing n98-magerun #####"
echo "##################################"
apt-get install wget
cd /tmp
wget https://files.magerun.net/n98-magerun2.phar
chmod +x ./n98-magerun2.phar
mv ./n98-magerun2.phar /usr/local/bin/magerun

echo "#################################"
echo "##### Installing PHPMyAdmin #####"
echo "#################################"
# PHPMyAdmin
export DEBIAN_FRONTEND=noninteractive
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections > /tmp/ignoreme
apt-get install apt-utils
apt-get install -y  php-gettext phpmyadmin > /tmp/ignoreme

# Magento 2 Installation from composer
echo "############################################"
echo "##### INSTALLING COMPOSER DEPENDENDIES #####"
echo "############################################"
#if [ -f /var/www/html/vagrant/composer.tar.gz ]; then
#    cd /root
#    mkdir ./.cache
#    tar -zxf /var/www/html/vagrant/composer.tar.gz -C /root/.cache/
#fi

cp /home/auth.json /root/.composer/auth.json
cp /home/composer.json /var/www/html/composer.json
cd /var/www/html
composer install --no-progress

#usename fc00ab765c82f441779aba26ccd91fcb
#password 19f903918cdd6292fddab9d6d2846ca7
#Do you want to store credentials for repo.magento.com in /root/.composer/auth.json

# Restart apache
echo "#############################"
echo "##### RESTARTING APACHE #####"
echo "#############################"
service apache2 restart

echo "##################################"
echo "##### INSTALLING MAILCATCHER #####"
echo "##################################"
apt-get install -y libsqlite3-dev ruby ruby-dev
gem install mailcatcher --conservative


apt-get update
apt-get install dos2unix

cp /usr/local/bin/mailcatcher /etc/init.d/mailcatcher
chmod +x /etc/init.d/mailcatcher
dos2unix /etc/init.d/mailcatcher
update-rc.d mailcatcher defaults
/etc/init.d/mailcatcher start
sed -ir "s@;\?sendmail_path =.*@sendmail_path = \"/usr/bin/env $(which catchmail) -f local\@host\"@" /etc/php/7.1/apache2/php.ini
sed -ir "s@;\?sendmail_path =.*@sendmail_path = \"/usr/bin/env $(which catchmail) -f local\@host\"@" /etc/php/7.1/cli/php.ini

echo "###################################"
echo "#### CONFIGURING WWW-DATA USER ####"
echo "###################################"
echo 'www-data:www-data' | chpasswd
usermod -s /bin/bash www-data
cp /home/sshd_config /etc/ssh/sshd_config
service ssh restart


echo "###########################"
echo "##### SETTING UP CRON #####"
echo "###########################"
cd /tmp
crontab -u www-data -l > cronfile
echo "
*/5 * * * * /usr/bin/php -c /etc/php/7.1/apache2/php.ini /var/www/html/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/html/var/log/magento.cron.log
*/5 * * * * /usr/bin/php -c /etc/php/7.1/apache2/php.ini /var/www/html/update/cron.php >> /var/www/html/var/log/update.cron.log
*/5 * * * * /usr/bin/php -c /etc/php/7.1/apache2/php.ini /var/www/html/bin/magento setup:cron:run >> /var/www/html/var/log/setup.cron.log
" >> cronfile
crontab -u www-data cronfile
rm ./cronfile
echo "#######################################"
echo "#### INSTALLING MAGENTO 2 FROM CLI ####"
echo "#######################################"
mysql -u root -proot magento  < /home/db.sql
cd /var/www/html/bin

php ./magento setup:install --admin-firstname="AdminUser" --admin-lastname="Person" --admin-email="demo.user@visionet.com" --admin-user="adminUser" --admin-password="passw0rd" --base-url="http://172.19.0.2/" --backend-frontname="admin" --db-host="localhost" --db-name="magento" --db-user="root" --db-password="root" --language="en_US" --timezone="America/New_York" --currency="USD" --use-rewrites="1" --use-secure="0" --use-secure-admin="0" --session-save="files"
echo "#################################"
echo "#### RSYNC OF STATIC CONTENT ####"
echo "#################################"
#mkdir -p /vagrant/vagrant/tmp/vendor
#rsync -r /var/www/html/vendor /vagrant/vagrant/tmp
#/etc/init.d/staticsync start   #did not run successfully
#/etc/init.d/gensync start		#did not run successfully

echo "#############################"
echo "#### FINAL MAGENTO SETUP ####"
echo "#############################"
cd /var/www/html
bin/magento setup:upgrade
bin/magento setup:di:compile
bin/magento maintenance:disable

echo "###########################################"
echo "#### FIXING VAR PERMISSIONS IN MAGENTO ####"
echo "###########################################"
mkdir -p /var/www/html/var
chmod -R 777 /var/www/html/var
cd /var/www/html
chown -R www-data:www-data /var/www/html
#if [ ! -f /vagrant/vagrant/composer.tar.gz ]; then
#    echo "###################################"
#    echo "#### BACKING UP COMPOSER CACHE ####"
#    echo "###################################"
#    cd /root/.cache
#    tar -zcf /vagrant/vagrant/composer.tar.gz ./composer
#fi

# Post Up Message
echo "Magento2 Vagrant Box ready!"

echo "Final installation instructions:"
echo "Close PHPStorm, edit the file {ROOT}/.idea/UNFI.iml"
echo "Add the contents of {ROOT}/vagrant/ExcludedDirectories.txt"
echo "to the tag <content url=\"...\"> as this will improve performance"
echo "by preventing PHPStorm from indexing test files."
echo ""
echo "Also, you will need to setup deployment. Please see the four images"
echo "named deployment1.png through deployment4.png for instructions."
echo "The username and password you should use is: www-data:www-data."
echo "After that you will be ready to develop."