#!/usr/bin/env python3

import requests, logging, datetime

logging.basicConfig(filename="dynip.log", level=logging.INFO)

def logEntry(string):
  logging.info(str(datetime.datetime.now())+" - "+string)
  print(string+"\n")

with open("new_ip.txt", "r") as file:
  new_ip = file.read()
file.close()

with open("old_ip.txt", "r") as file:
  old_ip = file.read()
file.close()

print("\nold: "+old_ip+"new: "+new_ip)

if old_ip == new_ip:
  logEntry('IP has not changed')
else:
  print("IP has changed!\ncontacting domains.google.com...\n")

  username = "" #put your google generated username here (between the quotes)
  password = "" #put your google generated password here
  domain = "" #put your Top Level Domain here (this needs to be the same as in the synthetic record on domains.google.com)

  url = "https://"+username+":"+password+"@domains.google.com/nic/update?hostname="+domain+"&myip="+new_ip
  head = {"User-Agent": "davidp-dynip/1.0"}

  r = requests.Request('GET',url,headers=head)
  pr = r.prepare()
  pr.url = pr.url.replace("%0A","")

  s = requests.Session()
  resp = s.send(pr)

  if "good" in resp.text:
    logEntry('IP successfully changed to '+new_ip)
  elif "nochg" in resp.text:
    logEntry('old_ip.txt and new_ip.txt are different, but new_ip is already set as the DNS record')
  else:
    outstring = 'ERROR!: Google says: '+resp.text
    logEntry(outstring)

  with open("old_ip.txt", "w") as file:
    file.write(new_ip)
  file.close()
