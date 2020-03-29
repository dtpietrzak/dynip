# dynip
Dynamically updates an Ubuntu Server's IP address on Google Domains

Using a combination of Bash and Python to automatically update a Google Domains DNS Record whenever your public IP changes for an Ubuntu Server (probably other unix systems as well). AKA DynamicDNS

This is only originally created to work with Google Domains, but could easily be adapted to any service taht offers an http accessible API if you know what you're doing. Look inside dynip.py for calling an API with python's requests module.

# INSTALLATION AND SETUP

First things first, you need to create a Synthetic Record on Google Domains for your A record (choose the Dynamic DNS option) 
https://support.google.com/domains/answer/6147083

Download this git repository
The folder can sit anywhere on the server. So place it where ever you want.
Open dynip.sh with whatever text editor or interface you prefer (Atom / Nano / Vim / TextEdit / etc.)
Change the path="" variable to the FULL path, wherever you put the dynip directory (including the dynlib directory)

Make a new file named dynip.conf, right in the dynip directory, and with whatever text editor or interface you prefer,
add your "username", "password", and "domain" variables with the information from your domains.google.com account
It should look something like "faF3dga9432GD jsfdk232rFDf33 website.org"
Check out dynip.conf_example to see an even better example of what it should look like.

Finally, you'll need to add a cron job by using "crontab -e" in terminal
This will periodically run the dynip.sh script
Add this line to the bottom, replacing [LOCATION] with the location of the dynip folder
Again, this location needs to be the FULL path to your dynip directory

*/10 * * * * /bin/bash /[LOCATION]/dynip.sh



That's all folks!

This will check your IP every 10 minutes, and update it on domains.google.com if it has changed.
