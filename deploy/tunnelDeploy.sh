#!/bin/sh

# check if the its the tunnel drive that was mounted
[ "$3" != "/Volumes/Tunnel" ] && exit 0

# wait for files to be for sure copied over, then create a fresh copy in the old directory
sleep 5
rm -rf ~/Documents/Processing/old/*
cp -r /Volumes/Tunnel/* ~/Documents/Processing/old/
mv ~/Documents/Processing/old/Reloaded.pde ~/Documents/Processing/old/current.pde

# kill the old tunnel process
ps -ef | grep Processing.app | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep processing-java | grep -v grep | awk '{print $2}' | xargs kill -9
rm -rf ~/Documents/Processing/current/output

# swap the current and old symlink
current=$(readlink ~/Documents/Processing/current)
old=$(readlink ~/Documents/Processing/old)
ln -nsf $old ~/Documents/Processing/current
ln -nsf $current ~/Documents/Processing/old

# run the new code, sleep to make sure startup has enough time to completely run
nohup processing-java --run --sketch=/Users/admin/Documents/Processing/current --output=/Users/admin/Documents/Processing/current/output > /tmp/test 2>&1 &
pid=$(echo $!)
sleep 10

# if new deploy fails then rollback
if ! ps -ef | grep " $pid " | grep -v grep; then 
	ln -nsf $old ~/Documents/Processing/current
	ln -nsf $current ~/Documents/Processing/old
	processing-java --run --sketch=/Users/admin/Documents/Processing/current --output=/Users/admin/Documents/Processing/current/output > /tmp/test 2>&1 &
	echo fail > /Volumes/Tunnel/resulttemp
else
	echo success > /Volumes/Tunnel/resulttemp
fi


chmod 777 /Volumes/Tunnel/resulttemp
mv /Volumes/Tunnel/resulttemp /Volumes/Tunnel/result
