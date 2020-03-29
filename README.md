# dynip
Dynamically updates an Ubuntu Server's IP address on Google Domains

Using a combination of Bash and Python to automatically update a Google Domains DNS Record whenever your public IP changes for an Ubuntu Server (probably other unix systems as well). AKA DynamicDNS

This is only originally created to work with Google Domains, but could easily be adapted to any service taht offers an http accessible API if you know what you're doing. Look inside dynip.py for calling an API with python's requests module.

# INSTALLATION AND SETUP

First things first, you need to create a Synthetic Record on Google Domains for your A record (choose the Dynamic DNS option)

Download this git repository
The folder can sit anywhere on the server. So place it where ever you want.

Open dynip.py with whatever text editor or python interface you prefer
Edit the "username", "password", and "domain" variables with your information on domains.google.com

You'll need to add a cron job by using "crontab -e" in terminal, in order to periodically run the dynip.sh script
Add this line to the bottom, replacing [LOCATION] with the location of the dynip folder

*/10 * * * * /bin/bash /[LOCATION]/dynip.sh

This will check your IP every 10 minutes, and update it on domains.google.com if it has changed.
