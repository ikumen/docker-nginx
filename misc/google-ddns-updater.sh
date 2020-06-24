#!/bin/sh

# The domain to register our IP to
hostname=$GOOGLE_DDNS_HOST
username=$GOOGLE_DDNS_USER
passwd=$GOOGLE_DDNS_PASSWD
user_email=$USER_EMAIL
update_url="https://domains.google.com/nic/update?hostname=${hostname}"
# helpers
function get_current_ip() {
  echo $(curl -s --retry 10 --retry-delay 10 https://domains.google.com/checkip)
}

# The ip's current registed to our domain
registered_ips=$(dig "$hostname" +short)
# Our current ip (seen from external source)
current_ip=$(get_current_ip)

# check if update is required
update_required=true
for ip in $registered_ips
do
  if [ "$current_ip" == "$ip" ]; then
    update_required=false
    break
  fi
done

if [ "$update_required" == true ]; then
  #echo $update_url
  credentials="$(echo -n "${username}:${passwd}" | base64)"
  resp=$(curl -s -X POST -H "Authorization: Basic $credentials" -H "User-Agent: google-ddns-updater ${user_email}" $update_url)
  echo $resp
fi
