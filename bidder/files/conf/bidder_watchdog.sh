#!/bin/bash
declare -i fcap_50=$(/usr/local/bin/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:9012/jmxrmi -O com.audiencescience.apollo.bidder.service.user.resolver:type=AbstractUdsUserResolver,name=frequencyCapRequests -A 50thPercentile | awk -F= '{print $2}')

if [ ! -z $fcap_50 ] && [ $fcap_50 -gt 80 ]; then
    fcap_mean=$(/usr/local/bin/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:9012/jmxrmi -O com.audiencescience.apollo.bidder.service.user.resolver:type=AbstractUdsUserResolver,name=frequencyCapRequests -A Mean | awk -F= '{print $2}')
    BPS=$(/usr/local/bin/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:9012/jmxrmi -O Bidder:name=Stats -A BidsPerSecond | awk -F= '{print $2}')
    /usr/bin/logger "Frequency Cap 50th percentile too high (50th=${fcap_50}, Mean=${fcap_mean}, BPS=${BPS}). Restarting tomcat."
    if [ "$1" == "-v" ]; then
        echo "Frequency Cap 50th percentile too high (50th=${fcap_50}, Mean=${fcap_mean}, BPS=${BPS}). Restarting tomcat."
    fi
    /etc/init.d/tomcat restart
elif [ "$1" == "-v" ]; then
    fcap_mean=$(/usr/local/bin/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:9012/jmxrmi -O com.audiencescience.apollo.bidder.service.user.resolver:type=AbstractUdsUserResolver,name=frequencyCapRequests -A Mean | awk -F= '{print $2}')
    BPS=$(/usr/local/bin/check_jmx -U service:jmx:rmi:///jndi/rmi://localhost:9012/jmxrmi -O Bidder:name=Stats -A BidsPerSecond | awk -F= '{print $2}')
    echo "Frequency Cap 50th percentile is OK: 50th=${fcap_50}, Mean=${fcap_mean}, BPS=${BPS}"
fi
