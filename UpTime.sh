#! /bin/sh

# if $4 from `uptime` is "mins," then the system has been up for less than an hour. 
# We set $timeup to the output of $3, appending only "m".
timechk=`uptime | awk '{ print $4 }'`

if [ $timechk = "mins," ]; then
        timeup=`uptime | awk '{ print $3 "m" }'`

# if $4 is "days," then we generate a readable string from $3, $4, and $5;
elif [ $timechk = "days," ]; then

                timeup=`uptime | awk '{ print $3 $4 " " $5 }' | sed 's/days,/d/g' | sed 's/:/h /g' | sed 's/,/m/g'`

# otherwise, generate a readable string from $3.
else

                timeup=`uptime | awk '{ print $3 }' | sed 's/:/h /g' | sed 's/,/m/g'`

fi

echo "<result>$timeup</result>"
