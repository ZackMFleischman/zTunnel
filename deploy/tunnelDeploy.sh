#!/bin/sh

# check if the its the tunnel drive that was mounted
[ $3 != "/Volumes/Tunnel" ] && exit 0

# wait for files to be for sure copied over, then create a fresh copy in the old directory
sleep 2s
rm -rf /Users/admin/Documents/Processing/old/*
cp /Volumes/Tunnel/* /Users/admin/Documents/Processing/old/
mv /Users/admin/Documents/Processing/old/Reloaded.pde /Users/admin/Documents/Processing/old/current.pde

# kill the old tunnel process
ps -ef | grep Processing.app | grep -v grep | awk '{print $2}' | xargs kill -9
ps -ef | grep processing-java | grep -v grep | awk '{print $2}' | xargs kill -9
rm -rf /Users/admin/Documents/Processing/current/output

# swap the current and old symlink
current=$(readlink /Users/admin/Documents/Processing/current)
old=$(readlink /Users/admin/Documents/Processing/old)
ln -nsf $old current
ln -nsf $current old

# run the new code, sleep to make sure startup has enough time to completely run
nohup processing-java --run --sketch=/Users/admin/Documents/Processing/current --output=/Users/admin/Documents/Processing/current &
pid=$(echo $!)
sleep 5s

# if new deploy fails then rollback
if ! ps | grep -v grep | grep " $pid "; then 
	ln -nsf $old current
	ln -nsf $current old
	processing-java --run --sketch=/Users/admin/Documents/Processing/current --output=/Users/admin/Documents/Processing/current &
	echo fail > /Volumes/Tunnel/result
else
	echo success > /Volumes/Tunnel/result
fi