#!/bin/bash




# you need to set this to the FULL path of the dynip directory
path="/home/david/Desktop/server/github/dynip/"
# dont forget to also create the dynip.conf file
# see dynip.conf_example for an... example




log="dynip.log"
newip="new_ip.txt"
rotate="rotation.txt"
rot=$(<$path$rotate)

ip_sites=(ifconfig.me/ip v4.ident.me ipv4.icanhazip.com ipecho.net/plain ipinfo.io/ip checkip.amazonaws.com)
num_of_sites=${#ip_sites[@]}

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
    ip1=$(curl -s ${ip_sites[$i1]})
    ip2=$(curl -s ${ip_sites[$i2]})
    echo "INFO:" ${ip_sites[$i1]} ":"  $ip1 "  -  " ${ip_sites[$i2]} ":" $ip2 >> $path$log
    if [ $ip1 = $ip2 ]
    then
      echo $ip1 > $path$newip
    else
      echo "IPs don't match, will try again later..." >> $path$log
    fi
    echo $i2 > $path$rotate
  fi
done

cd $path && ./dynip.py >> $path$log
