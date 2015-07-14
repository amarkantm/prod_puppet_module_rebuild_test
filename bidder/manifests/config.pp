## Bidder config details

class bidder::config {

    $build = 'apollo-bidder-110.4.war'

    $rtbbid_tomcat_dirs = [

        '/var/rsi/rtb/',
        '/var/rsi/tomcat/webapps/rtbbidder',
        '/var/rsi/tomcat/work/rtbbidder',
        '/var/rsi/tomcat/tmp/rtbbidder',
        '/var/rsi/logs/rtbbidder']

    File {
        owner   => tomcat,
        group   => tomcat,
        require => Class['tomcat::install']
    }

    file {


        ### recursivly copied dirs ###
        '/var/rsi/wars/':
            mode    => '0444',
            recurse => inf,
            purge   => true,
            source  => 'puppet:///modules/bidder/war';

        '/usr/local/tomcat/conf/server.xml':
            mode   => '0444',
            source => 'puppet:///modules/bidder/conf/server.xml';

#        "/var/rsi/rtb/":
#           ensure       => directory,
#           mode         => 755;

        '/var/rsi/rtb/VoldemortConfig.xml':
            mode    => '0444',
            content => template('bidder/VoldemortConfig.xml.erb');

        '/var/rsi/tomcat/webapps/rtbbidder/rtbbidder.war':
            ensure  => link,
            force   => true,
            target  => "/var/rsi/wars/${build}";

        '/usr/local/sbin/tomcat-rebuild.sh':
            mode   => '0744',
            owner  => root,
            group  => root,
            source => 'puppet:///modules/bidder/conf/tomcat-rebuild.sh';

        '/usr/local/bin/check_jmx':
            mode   => '0755',
            owner  => root,
            group  => root,
            source => 'puppet:///modules/bidder/nrpe/check_jmx';

#        "/usr/local/bin/jmxquery.jar":
#            mode   => 755,
#            owner  => root,
#            group  => root,
#            source => "puppet:///modules/bidder/nrpe/jmxquery.jar";

        '/usr/local/bin/bidder_watchdog.sh':
            mode   => '0755',
            owner  => root,
            group  => root,
            source => 'puppet:///modules/bidder/conf/bidder_watchdog.sh';

        '/var/rsi/rtb/codes':
            ensure => link,
            mode   => '0755',
            target => '/var/rsi/codes',
            force  => true;

        '/var/rsi/codes':
            ensure      => directory,
            owner       => tomcat,
            group       => tomcat,
            mode        => '0755',
            links       => follow,
            backup      => false,
            recurse     => true,
            recurselimit    => 1,
            require     => File['/var/rsi'];

        '/var/rsi/codes/country_codes.tab':
            owner   => tomcat,
            group   => tomcat,
            mode  => '0755',
            source => 'puppet:///modules/bidder/codes/country_codes.tab';

        '/var/rsi/codes/region_codes.tab':
            owner   => tomcat,
            group   => tomcat,
            mode  => '0755',
            source => 'puppet:///modules/bidder/codes/region_codes.tab';

        '/var/rsi/codes/city_codes.tab':
            owner   => tomcat,
            group   => tomcat,
            mode  => '0755',
            source => 'puppet:///modules/bidder/codes/city_codes.tab';

        '/var/rsi/rtb/server.info':
            ensure  => present,
      mode    => '0444',
            require => File['/var/rsi/rtb'],
            content => $build;

#        "/home/tomcat/.ssh/config":
#            owner   => tomcat,
#            group   => tomcat,
#            mode    => 644,
#            content  => "Host *\n\tStrictHostKeyChecking no\n"
#
#        "/var/rsi/rtb/OverrideConfig.properties":
#            mode => '0444',
#            owner => tomcat,
#            group => tomcat,
#            content => template('tomcat/OverrideConfig.properties.erb',
#                                'tomcat/OverrideConfig.properties.provider.erb',
#                                'tomcat/OverrideConfig.properties.voldemort.erb',
#                                'tomcat/OverrideConfig.properties.rtusdb.erb',
#                                'tomcat/OverrideConfig.properties.zookeeper.erb');

        '/var/rsi/rtb/OverrideConfig.properties':
            mode => '0444',
            owner => tomcat,
            group => tomcat,
            source => 'puppet:///modules/bidder/conf/OverrideConfig.properties';

        '/usr/local/tomcat/logs':
            ensure => link,
            force  => true,
            target => '/var/rsi/logs/rtbbidder';

        '/var/rsi/rtb/log4j.properties':
            mode    => '0664',
            source  => 'puppet:///modules/bidder/conf/log4j.properties';

        $rtbbid_tomcat_dirs:
            ensure => directory,
            mode   => '0775',
            owner  => 'tomcat',
            group  => 'tomcat';

    }
}

