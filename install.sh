#!/usr/bin/env bash

# Variable
WEBDIR="/var/www/html"
DEMO="/var/www/html/demo"

echo "
    ##------------------------------------------------------//
    ##       Script d'installation de la VM Ubuntu          //
    ##                  Technical Test By ..                //
    ##------------------------------------------------------//
"

# Check if user is sudoer
if [ $(whoami) != "root" ]; then
	echo "\nAlert: l'utilisation du script doit ce faire en sudo...\n"
	exit
fi

# Nettoyage des dépendences
apt-get-get -y update
rm -rf /var/lib/apt/lists/*
apt-get -y update

# MAJ et Installation des paquets basique
apt-get -y upgrade
apt-get -y install htop zip iotop iptraf

# Paramètrage du nom d'hôte: hostname
echo "test.local" > /etc/hostname
hostname test.local

# ---------------------------------------
#    Apache, PHP, Mysql, PhpMyAdmin... 
#      Set your command line Here
# ---------------------------------------

# ---------------------------------------------
#                 Apache Setup
# ---------------------------------------------

# Apache Install
apt-get install apache2 -y

# Ajout du compte vagrant à www-data
adduser vagrant www-data

# ---------------------------------------------
#                PHP/MySql Setup
# ---------------------------------------------

# Utilisé en ligne de commande uniquement
export DEBIAN_FRONTEND="noninteractive"

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Installation des packets php/mysql
apt-get install -y php libapache2-mod-php mysql-server php-mysql php-intl
apt-get install php7.4-sqlite

# Modification des valeurs date.timezone
sed -i '/^date.timezone/d' /etc/php/7.4/apache2/php.ini
echo "date.timezone = Indian/Antananarivo" >> /etc/php/7.4/apache2/php.ini

sed -i '/^date.timezone/d' /etc/php/7.4/cli/php.ini
echo "date.timezone = Indian/Antananarivo" >> /etc/php/7.4/cli/php.ini

# ---------------------------------------------
#               PHPMyAdmin setup
# ---------------------------------------------

# Default PHPMyAdmin Settings
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

# Install PHPMyAdmin
apt-get install -y phpmyadmin

# Inclure le fichier conf de PhpMyAdmin
echo "include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Restarting apache to make changes
service apache2 restart

# ---------------------------------------------
#                Composer Setup
# ---------------------------------------------

# Installation des sources
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer


# ---------------------------------------------
#        Configure VHOST Apache
# ---------------------------------------------

# Ajout du ServerName (FQDN) dans le fichier de config Apache
echo "ServerName test.local" >> /etc/apache2/apache2.conf

# Création du fichier Host
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName test.local
    ServerAdmin admin@test.local
    ServerAlias localhost
    DocumentRoot /var/www/html/demo/public

    <Directory /var/www/demo/public>
        AllowOverride None
        Order Allow,Deny
        Allow from All

        <IfModule mod_rewrite.c>
            Options -MultiViews
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ index.php [QSA,L]
        </IfModule>
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error_monsite.log
    CustomLog ${APACHE_LOG_DIR}/access_monsite.log combined
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/test.conf

# Reconfigure Apache
a2enmod rewrite
a2ensite test.conf
a2dissite 000-default.conf
service apache2 restart

# ---------------------------------------
#     Install Web project from Github
#       Set your command line Here
# ---------------------------------------

# Go to /var/www/html
cd /var/www/html/

# clone the repo with git
git clone https://github.com/samir755/demo

# Enter the demo folder
cd /var/www/html/demo/

# Install symfony vendor
composer require symfony/runtime --no-interaction
composer install

# Generate database; set right and local fixtures
php bin/console d:d:c --no-interaction
php bin/console d:s:u --force --no-interaction

# Change right
chown -R root:www-data ../demo
chmod -R 775 var

# Run synfony
php bin/console doctrine:fixtures:load --no-interaction

echo "###################################################"
echo "######## Congrats, Ubuntu VM is install !  ########"
echo "###################################################"
echo ""
echo "Login:pass for local VM: vagrant:vagrant"
echo ""
echo "By ..."

exit