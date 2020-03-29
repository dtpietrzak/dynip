#!/usr/bin/env python3


import requests, datetime

# function to simplify printing to the log
def logEntry(string):
  print(str(datetime.datetime.now())+" - "+string+"\n")

# get the settings from the dynip.conf
with open("dynip.conf", "r") as file:
  settings = file.read()
  set = settings.split()
  username = set[0]
  password = set[1]
  domain = set[2]

# get the new ip from the lastest check
with open("new_ip.txt", "r") as file:
  new_ip = file.read()
file.close()

# get the old ip from the last change
with open("old_ip.txt", "r") as file:
  old_ip = file.read()
file.close()

# if IPs are different, that means it's changed.
if old_ip != new_ip:
  logEntry('IP has changed, contacting domains.google.com')

# GET it! GET it?
  url = "https://"+username+":"+password+"@domains.google.com/nic/update?hostname="+domain+"&myip="+new_ip
  head = {"User-Agent": "davidp-dynip/1.0"}

  r = requests.Request('GET',url,headers=head)
# this is a little hack to get rid of the newline that requests adds to the URL
  pr = r.prepare()
  pr.url = pr.url.replace("%0A","")
  s = requests.Session()
  resp = s.send(pr)

# google accepted the new IP
  if "good" in resp.text:
    logEntry('IP successfully changed to '+new_ip)
# google said the new url is the same as the old one
  elif "nochg" in resp.text:
    logEntry('old_ip.txt and new_ip.txt are different, but new_ip is already set as the DNS record')
# google threw some other error.
# see this link for details
# https://support.google.com/domains/answer/6147083
  else:
    outstring = 'ERROR!: Google says: '+resp.text
    logEntry(outstring)

# write the new ip to the old_ip.txt file
  with open("old_ip.txt", "w") as file:
    file.write(new_ip)
  file.close()

# print to the log that nothing changed
else:
  logEntry('No change')
