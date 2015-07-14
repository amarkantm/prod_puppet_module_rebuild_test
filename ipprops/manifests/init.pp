# == Class: ipprops
#
# Full description of class ipprops here.
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
#  class { ipprops:
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
class ipprops {

    file {
        '/var/rsi/rtb/ipprops.config':
            mode    => '0444',
            owner   => tomcat,
            group   => tomcat,
            require => File['/var/rsi/rtb'],
            ensure  => present;

        '/var/rsi/rtb/ipprops':
            ensure => link,
            mode   => '0755',
            target => '/var/rsi/ipprops',
            force  => true;

        '/var/rsi/ipprops':
            ensure      => directory,
            owner       => tomcat,
            group       => tomcat,
            mode        => '0755',
            checksum    => mtime,
            links       => follow,
            backup      => false,
            recurse     => true,
            recurselimit    => 1,
            require     => Class['bidder::config'];

        '/var/rsi/ipprops-archive':
            ensure      => directory,
            owner       => tomcat,
            group       => tomcat,
            mode        => '0755',
            checksum    => mtime,
            links       => follow,
            backup      => false,
            recurse     => true,
            recurselimit    => 1,
            require     => Class['bidder::config'],
            source      => 'puppet:///modules/ipprops/ipprops-archive';

  }
}
