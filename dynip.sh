#!/bin/bash

echo
echo
echo "running dynip.sh"
echo "- - - - - - - - "
echo

echo "getting current IP"
rot=$(<rotation.txt)
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
    echo "INFO:" ${ip_sites[$i1]} ":"  $ip1 "  -  " ${ip_sites[$i2]} ":" $ip2 >> dynip.log
    if [ $ip1 = $ip2 ]
    then
      echo $ip1 > new_ip.txt
    else
      echo
      echo "IPs don't match, I will try again later..."
      echo "IP MATCH ERROR!" >> dynip.log
    fi
    echo $i2 > rotation.txt
  fi
done

./dynip.py

echo "- - - - - - - - "
echo "done"
echo
echo
echo
