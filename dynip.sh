#!/bin/bash




# you need to set this to the FULL path of the dynip directory
path="/home/david/Desktop/server/github/dynip/"
# dont forget to also create the dynip.conf file
# see dynip.conf_example for an... example


# set whether debug mode is on
# debug mode sends various info to dynip.log
# turn this on while testing things, or if something doesn't work
debug=false
# setting the file names
log="dynip.log"
newip="new_ip.txt"
rotate="rotation.txt"
# get the rotation number from the rotation file
rot=$(<$path$rotate)

# this is an array of websites used to get your public IP
# I've written this to cycle through the websites, to lower the load on each
# these people / organizations are great for offering this service for free
# please do not abuse them
# please keep your cycle time to 10 min or above (set in crontab -e)
ip_sites=(ifconfig.me/ip v4.ident.me ipv4.icanhazip.com ipecho.net/plain ipinfo.io/ip checkip.amazonaws.com)
# gets the number of items in ip_sites
num_of_sites=${#ip_sites[@]}

# this is the cycling script
# it sends requests to two of the ip_sites each time dynip.sh is run
# rotation.txt is used to remember which two ip_sites to use next
num1=0
num2=1
until [ $num1 -ge $num_of_sites ]
do
  num1=$(( $num1 + 1 ))
  if [ $num2 -eq $num_of_sites ]
  then
    num2=1
  else
    num2=$(( $num2 + 1 ))
  fi
  i1=$(( $num1 - 1 ))
  i2=$(( $num2 - 1 ))

  if [ $rot -eq $i1 ]
  then
    # this gets the ip_sites' requests to variables
    ip1=$(curl -s ${ip_sites[$i1]})
    ip2=$(curl -s ${ip_sites[$i2]})
    # if debug is on, this will print the ip_sites used and the ips they determined
    if [ "$debug" = true ] ; then
      echo "INFO:" ${ip_sites[$i1]} ":"  $ip1 "  -  " ${ip_sites[$i2]} ":" $ip2 >> $path$log
    fi
    # if both ip_sites agree about your pubic IP
    if [ $ip1 = $ip2 ]
    then
      # write the IP to new_ip.txt
      echo $ip1 > $path$newip
    else
      # if the two ip_sites disagree, send a note to the dynip.log that it failed here
      echo "IPs don't match, will try again later..." >> $path$log
    fi
    # rotate the rotation.txt file
    echo $i2 > $path$rotate
  fi
done

# if debug is on, the send the outs of the python script to dynip.log
if [ "$debug" = true ] ; then
  cd $path && ./dynip.py >> $path$log
else
  cd $path && ./dynip.py
fi
