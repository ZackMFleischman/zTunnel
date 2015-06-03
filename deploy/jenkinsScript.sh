#!/bin/sh

GLOBIGNORE=deploy:.*:libraries

# mount the empty drive then copy over all the files
cp ~/Tunnel.dmg deploy/Tunnel.dmg
hdiutil attach deploy/Tunnel.dmg
cp -r * /Volumes/Tunnel/

# wait for automated script to do its thing after mounting the drive
while [ ! -f /Volumes/Tunnel/result ]
do
  sleep 1
done

# check the result file to know if the deploy was successful
cat /Volumes/Tunnel/result | grep success
result=$(echo $?)
hdiutil detach /Volumes/Tunnel
exit $result