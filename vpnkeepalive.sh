#! /bin/sh
# from https://www.linuxquestions.org/questions/linux-networking-3/openvpn-does-not-reconnect-621097/

#uncomment the line for debug_out you want to use
#use /dev/stdout only when not calling from cron
debug_out=/dev/null
#debug_out=/dev/stdout
#NEXTHOP is a host at the other site of the VPN
NEXTHOP=192.168.1.145
OPEN_VPN_CMD="systemctl restart openvpn@client.service"

PING=/bin/ping

logger_opts="-t $0"
if [ "$debug_out" = "/dev/stdout" ]
then
        logger_opts="$logger_opts -s"
fi

pckts_rcvd=`$PING -c 8 -q -W 2 $NEXTHOP | grep transm | awk '{print $4}'`
echo "host: $NEXTHOP, pckts_rcvd: $pckts_rcvd" >$debug_out
if [ $pckts_rcvd -eq 0 ]
then
        echo "Connection with $NEXTHOP lost, resetting" | logger $logopts
        $OPEN_VPN_CMD > $debug_out
else
        echo "Connection with $NEXTHOP up, no action" | logger $logopts
fi

