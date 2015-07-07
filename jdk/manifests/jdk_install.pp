# == Class: jdk
#
# Full description of class jdk here.
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
#  class { jdk:
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
class jdk_install($package='jdk') {

## install ##
    package {
        "${package}":
            ensure   => installed,
            provider => 'rpm',
            source   => "/tmp/${package}", 
	    require  => File["/tmp/${package}"];
    }

   file { 
     "/tmp/${package}":
       source => "puppet:///modules/jdk/${package}";
}
## config ##

    File {
        owner => root,
        group => root
    }

    file {

        "/var/lib/java":
            ensure => directory,
            mode   => 755;

        "/etc/bashrc.d/":
            ensure => directory,
            mode   => 755;

        "/var/lib/java/dumps":
            ensure => directory,
            mode   => 1777;

        "/usr/bin/java":
            ensure  => link,
            target  => "/usr/java/default/bin/java",
            require => Package["${package}"];

        "/usr/bin/jar":
            ensure  => link,
            target  => "/usr/java/default/bin/jar",
            require => Package["${package}"];

        "/usr/bin/javac":
            ensure  => link,
            target  => "/usr/java/default/bin/javac",
            require => Package["${package}"];

        "/usr/bin/jhat":
            ensure  => link,
            target  => "/usr/java/default/bin/jhat",
            require => Package["${package}"];

        "/usr/bin/jmap":
            ensure  => link,
            target  => "/usr/java/default/bin/jmap",
            require => Package["${package}"];

        "/usr/bin/jstat":
            ensure  => link,
            target  => "/usr/java/default/bin/jstat",
            require => Package["${package}"];

 }
}
