#!/bin/bash

if [[ "$zehrapass" == '' ]]
then
	echo 'Set server password as $zehrapass environment variable and rerun!'
	exit 255
fi

runrestart ()
{
	kill `cat /home/bzflag/soccer/bzfssoccer.pid` >/dev/null 2>&1
	sleep 1
	kill `cat /home/bzflag/soccer/bzfssoccer.pid` >/dev/null 2>&1
	sleep 1

	/usr/local/bin/bzfs \
	-publictitle 'BZFlag Soccer is Back!' \
	-publicaddr 'zehrasoccer.networkspeedy.com:5155' \
	-publickey "`cat /home/bzflag/soccer/listkey.txt`" \
	-p 5155 \
	-h -a 0 0 \
	-passwd "$zehrapass" \
	-ts \
	-srvmsg 'This server is operated by ZEHRA' \
        -srvmsg 'This server is hosted out of a Dallas-based datacenter.' \
	-srvmsg 'Authenticated players can /report to admins, /pollban, etc.' \
	-srvmsg 'ZERO TOLERANCE ON CHEATING! No Cursing! Team-kill is disabled.' \
	-admsg 'This server is operated by ZEHRA' \
        -admsg 'This server is hosted out of a Dallas-based datacenter.' \
	-admsg 'Authenticated players can /report to admins, /pollban, etc.' \
	-admsg 'ZERO-TOLERANCE CHEATING POLICY!  No profanity!  Team-kill is disabled.' \
	-disableBots \
	-filterChat \
	-filterCallsigns \
	-maxidle $((60*10)) \
	-reportfile '/home/bzflag/soccer/reportfile.txt' \
	-badwords '/home/bzflag/soccer/badwords.txt' \
	-pidfile '/home/bzflag/soccer/bzfssoccer.pid' \
	-banfile '/home/bzflag/soccer/banfile.txt' \
	-groupdb '/home/bzflag/soccer/groups.conf' \
	-userdb '/home/bzflag/soccer/users.conf' \
	-sb \
	-spamtime 10 \
	-spamwarn 5 \
	-tkkr 5 \
	-noTeamKills \
	-lagwarn 400 \
	-lagannounce 350 \
	-lagdrop 3 \
	-jitterwarn 20 \
	-jitterdrop 3 \
	-packetlosswarn 2 \
	-packetlossdrop 3 \
	-loadplugin chathistory,49 \
	-loadplugin TimeLimit,10,15 \
	-loadplugin logDetail \
	-timemanual \
	-world '/home/bzflag/soccer/soccer.bzw' \
		&& echo 'SOCCER BZFLAG Server Started'
}

run_with_logging () # send output to syslog
{
	runrestart 2>&1 | tee -a server.log | logger -t bzfssoccer
}

run () # daemonize bzfs
{
	run_with_logging & disown -a
}

run 
