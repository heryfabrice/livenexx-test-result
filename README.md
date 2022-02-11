# Result test for liveneex.fr by Fabrice
## Ho to deplay a test app based on symfony and php7.4 using vagran and virtualbox
## You nedd at least 1 gigs of RAM, 1 CPU, and more than 50 gigs of disque 

## What you need are:
- vagrant 2.2.16 or higher
- virtualbox 6.1 or higher
- vscode as IDE
- php 7.4
- apache 2.4


## First download and nstall vagrant on your windows machine
https://www.vagrantup.com/downloads

## Download and Install virtualbox
https://www.virtualbox.org/

## We will use port forwarding
###  So VM will be accessible via ssh on your host with port 2222 and the app will be available at port 4567 on your web browser
### HOST port   -> VM port
2222        -> 22
### And
4567        -> 80

## Create Directory (use windows CMD or Powershell)
mkdir TEST

## Enter the TEST folder
cd TEST

## Now download ubuntu focal64 box from vagrant repo
vagrant box add ubuntu/focal64

## Clone this repository
git clone https://github.com/heryfabrice/livenexx-test-result

## Go to the livenexx-test-result folder
cd livenexx-test-result

## Run vagrant up
vagrant up

## To poweroff the VM
vagrant halt

## If you want to verify something, just ssh to the VM using command bellow, the default user is vagrant and can use sudo to elevate privileges 
vagrant ssh

## then here we are, open this link now
## The demo up
http://localhost:4567/index.php

## phpmyadmin for mysql database administration
http://localhost:4567/phpmyadmin

## Enjoy your demo app :)

