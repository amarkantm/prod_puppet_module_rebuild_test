# == Class: bidder
#
# Full description of class bidder here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { bidder:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name puppet@example.com
#
# === Copyright
#
# Copyright (C) 2015 Amar Kant
#
class bidder::prod::config {

    $build = "apollo-bidder-110.4.war"

    File {
        owner   => tomcat,
        group   => tomcat,
        require => Class["tomcat::tomcat7_0_33"]
    }

    file {


        ### recursivly copied dirs ###
        "/var/rsi/wars/":
            mode    => 444,
            recurse => inf,
            purge   => true,
            source  => "puppet:///modules/bidder/war";

        "/usr/local/tomcat/conf/server.xml":
            mode   => 444,
            source => "puppet:///modules/bidder/conf/server.xml";

        "/var/rsi/rtb/":
            ensure       => directory,
            mode         => 755;

        "/var/rsi/rtb/VoldemortConfig.xml":
            mode    => 444,
            content => template("bidder/VoldemortConfig.xml.erb");


       "/var/rsi/tomcat/webapps/rtbbidder/rtbbidder.war":
            ensure  => link,
            force   => true,
            target  => "/var/rsi/wars/$build";

        "/usr/local/sbin/tomcat-rebuild.sh":
            mode   => 744,
            owner  => root,
            group  => root,
            source => "puppet:///modules/bidder/conf/tomcat-rebuild.sh";

        "/usr/local/bin/check_jmx":
            mode   => 755,
            owner  => root,
            group  => root,
            source => "puppet:///modules/bidder/nrpe/check_jmx";

        "/usr/local/bin/jmxquery.jar":
            mode   => 755,
            owner  => root,
            group  => root,
            source => "puppet:///modules/bidder/nrpe/jmxquery.jar";

        "/usr/local/bin/bidder_watchdog.sh":
            mode   => 755,
            owner  => root,
            group  => root,
            source => "puppet:///modules/bidder/conf/bidder_watchdog.sh";

       "/var/rsi/rtb/codes":
            ensure => link,
            mode   => 755,
            target => "/var/rsi/codes",
            force  => true;

        "/var/rsi/codes":
            ensure      => directory,
            owner       => tomcat,
            group       => tomcat,
            mode        => 755,
            links       => follow,
            backup      => false,
            recurse     => true,
            recurselimit    => 1,
            require     => File["/var/rsi"];

        "/var/rsi/codes/country_codes.tab":
            owner   => tomcat,
            group   => tomcat,
            mode  => 755,
            source => "puppet:///modules/bidder/codes/country_codes.tab";

        "/var/rsi/codes/region_codes.tab":
            owner   => tomcat,
            group   => tomcat,
            mode  => 755,
            source => "puppet:///modules/bidder/codes/region_codes.tab";

        "/var/rsi/codes/city_codes.tab":
            owner   => tomcat,
            group   => tomcat,
            mode  => 755,
            source => "puppet:///modules/bidder/codes/city_codes.tab";

        "/var/rsi/rtb/server.info":
            mode    => 444,
            require => File["/var/rsi/rtb"],
            content => "$build",
            ensure  => present;

        "/home/tomcat/.ssh/config":
            owner   => tomcat,
            group   => tomcat,
            mode    => 644,
            content  => "Host *\n\tStrictHostKeyChecking no\n"

    }
}

class bidder::prod::service {
    service{
        "tomcat":
                    ensure    => running,
                    require   => Class["bidder::prod::config"],
                    hasstatus => true;
    }
}



class bidder {


include  bidder::prod::config,
         bidder::prod::service

}
