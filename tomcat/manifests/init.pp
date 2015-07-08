# == Class: tomcat
#
# Full description of class tomcat here.
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
#  class { tomcat:
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

class tomcat::epel {

package { 'epel-release':
	ensure => 'installed'
      }
}

class tomcat::tomcat7_0_33 {
    class {
        'tomcat7':
            package => 'tomcat-7.0.33'
    }
}

class tomcat::rtbbidder::dir {


    $rtbbid_tomcat_dirs = [

#        '/var/rsi/rtb/',
        '/var/rsi/tomcat/webapps/rtbbidder',
        '/var/rsi/tomcat/work/rtbbidder',
        '/var/rsi/tomcat/tmp/rtbbidder',
        '/var/rsi/logs/rtbbidder']

    file {

        '/var/rsi/logs/':
            ensure => directory,
            mode   => '0775',
            owner  => 'as',
            group  => 'as';

        '/var/rsi/rtb/log4j.properties':
            mode    => '0664',
            source  => 'puppet:///modules/tomcat/tomcat/log4j.properties';

        $rtbbid_tomcat_dirs:
            ensure => directory,
            mode   => '0775';

        '/usr/local/tomcat/logs':
            ensure => link,
            force  => true,
            target => '/var/rsi/logs/rtbbidder';

#        '/usr/local/tomcat/bin/setenv.sh':
#            mode   => '0755',
#            content => template('tomcat/setenv.erb');

#        '/usr/local/tomcat/conf/web.xml':
#            mode   => '0644',
#            source => 'puppet:///modules/tomcat/tomcat/web.xml';

        '/etc/logrotate.scribe.hourly.conf':
            ensure => absent;

        '/etc/cron.hourly/logrotate.scribe':
            ensure => absent;

#        '/etc/init.d/tomcat':
#            owner  => root,
#            group  => root,
#            mode   => '0755',
#            source => 'puppet:///modules/tomcat/tomcat/tomcat_init';

#        '/usr/local/tomcat/bin/nodeStatus.pl':
#            owner  => root,
#            group  => root,
#            mode   => '0755',
#            source => 'puppet:///modules/tomcat/tomcat/nodeStatus.pl';


        '/var/rsi/rtb/OverrideConfig.properties':
            mode => '0444',
            owner => tomcat,
            group => tomcat,
            content => template('tomcat/OverrideConfig.properties.erb',
                                'tomcat/OverrideConfig.properties.provider.erb',
                                'tomcat/OverrideConfig.properties.voldemort.erb',
                                'tomcat/OverrideConfig.properties.rtusdb.erb',
                                'tomcat/OverrideConfig.properties.zookeeper.erb');

#        '/home/tomcat/scribe_resend_updated.py':
#            mode    => '0755',
#            owner   => tomcat,
#            group   => tomcat,
#            source => 'puppet:///modules/tomcat/tomcat/scribe_resend_updated.py';

    }
}

class tomcat {

include tomcat::epel,
  tomcat::tomcat7_0_33
#  tomcat::rtbbidder::dir

}

