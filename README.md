# Result test for liveneex.fr by Fabrice

# Ho to deplay a test app based on symfony and php7.4 using vagran and virtualbox
# You nedd at least 1 gigs of RAM, 1 CPU, and more than 50 gigs of disque 

# What you need are:
- vagrant
- virtualbox
- vscode as IDE

# First download and nstall vagrant on your windows machine
https://www.vagrantup.com/downloads

# Download and Install virtualbox
https://www.virtualbox.org/

# Create Directory (use windows CMD or Powershell)
mkdir TEST
cd TEST

# Now download ubuntu focal64 box from vagrant repo
vagrant box add ubuntu/focal64

# Clone this repository
git clone https://github.com/heryfabrice/livenexx-test-result

# Go to the livenexx-test-result folder
cd livenexx-test-result

# Run vagrant up
vagrant up

# then here we are, open this link now
# The demo up
http://localhost:4567/index.php

# phpmyadmin for mysql database administration
http://localhost:4567/phpmyadmin

# Enjoy your demo app :)

