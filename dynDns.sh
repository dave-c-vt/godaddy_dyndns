#!/bin/bash


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


# FILENAMES
NEWIPFILE=.new_ip
OLDIPFILE=.old_ip

if [ ! -f $OLDIPFILE ]
then
    touch $OLDIPFILE
fi

dig +short myip.opendns.com @resolver1.opendns.com > $NEWIPFILE

NEWIP=$(cat $NEWIPFILE)
OLDIP=$(cat $NEWIPFILE)
DIFF=$(diff $NEWIPFILE $OLDIPFILE)
LOGFILE=$HOME/dns.log

function send_email() {

    if [ ${SENDEMAIL:+1} ] 
    then

        curl --url smtp://$SMTPSERVER:587 --ssl-reqd \
             --mail-from $SENDEMAIL \
             --mail-rcpt $RECVEMAIL \
             --user $SENDEMAIL:$EMAILPASS \
             -T <(echo -e "From: $SENDEMAIL\nTo: $RECVEMAIL\nSubject: $SUBJECT\n\n$NEWIP")
    fi
}


function update_dns() {
    # uses godaddy v1 api to update dns on ip address change
    key=$GODADDYKEY
    secret=$GODADDYSEC
    headers="Authorization: sso-key $key:$secret"

    for domain in "${DOMAINS[@]}"
    do
        for name in "@" "mx"
        do
            echo "[$(date)] [SETTING] $domain $name $NEWIP" >> $LOGFILE
            res=$(curl -s -X PUT "https://api.godaddy.com/v1/domains/${domain}/records/A/${name}" -H "Authorization: sso-key ${key}:${secret}" -H "Content-Type: application/json" -d " [{\"data\": \"${NEWIP}\"}]")
            echo $res

        done
    done
}


if [ "$NEWIP" != "" ] && [ "$DIFF" != ""  ]
then

    echo "[$(date)] [CHANGE] new IP address: $NEWIP" >> $LOGFILE

    send_email
    update_dns

    echo "$NEWIP" > $OLDIPFILE

fi


