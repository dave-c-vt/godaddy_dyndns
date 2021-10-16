# ![godaddy_dyndns](http://www.gravatar.com/avatar/42ca8c58c2bfd3de83e8c8d4261ed47e?d=mm&s=48) godaddy_dyndns!

## summary

this repo is made to help those who are self-hosting web services and using GoDaddy for domain listing
service.

if you have GoDaddy domains and you find yourself manually changing the @ and mx listings in GoDaddy
every time your ISP changes your IP address, AND you run Linux, this will be helpful for you!

## installation

### clone this repository

``` bash
git clone https://github.com/dave-c-vt/godaddy_dyndns
cd godaddy_dyndns
```

### get your GoDaddy API key/secret

go to https://developer.godaddy.com/keys and follow the instructions there.

### update the settings in the dynDns.sh file

``` bash
# GODADDY SETTINGS
#  - see https://developer.godaddy.com/keys to create your key/secret pair
GODADDYKEY="goDaddyKey"
GODADDYSEC="goDaddySecret"

# DOMAINS TO UPDATE
declare -a DOMAINS=("domain1.com" "domain2.com" "domain3.cloud")


# EMAIL SETTINGS
SENDEMAIL=sendemail@email.com   # set to "" to not send email
EMAILPASS=emailPassword
SMTPSERVER=email.com
RECVEMAIL=recpipient@someemail.com
SUBJECT="IP ADDRESS CHANGE"
```

### add to crontab

``` bash
SCRIPT=$(pwd)/dynDns.sh
crontab -l | grep -v "$SCRIPT" > crontab.txt && echo "* * * * * $SCRIPT" >> crontab.txt && crontab crontab.txt
```

## further info

- GoDaddy API usage - https://developer.godaddy.com/
