# == Class: scribe
#
# Full description of class scribe here.
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
#  class { scribe:
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
class scribe {

# Ensure /etc/passwd exists

#  file { '/etc/passwd':
#    ensure => 'file',
#    owner  => 'root',
#    group  => 'root',
#    mode   => '0644',
#}

  user { 'scribe':
      ensure   => 'present',
      comment  => 'scribe user',
      gid      => '413',
      managehome => true,
      home     => '/home/scribe',
      shell    => '/bin/bash',
      uid      => '413',
      require  => File['/etc/passwd'],
    }

  group { 'scribe':
        ensure   => 'present',
        gid      => '413',
    }

include scribe::repo,
#	scribe::install,
        scribe::dir
#        scribe::service

}

class scribe::install {
      
    package {
        "scribe.x86_64":
            ensure   => present,
    }


    package {
        "scribe-python.x86_64":
            ensure   => present,
    }

}

class scribe::dir {

    file {

         "/var/rsi/scribe/scribe.conf":
            mode   => 444,
            owner  => scribe,
            group  => scribe,
            content => template('scribe/rtbbid_scribe_conf.erb');


        "/var/rsi/logs/scribe/buffer0":
            ensure => directory,
            mode   => 755,
            owner  => scribe,
            group  => scribe;

        "/var/rsi/logs/scribe/buffer1":
            ensure => directory,
            mode   => 755,
            owner  => scribe,
            group  => scribe;

        "/var/rsi/logs/scribe//perm0":
            ensure => directory,
            mode   => 755,
            owner  => scribe,
            group  => scribe;

      }

    File {
        owner  => scribe,
        group  => scribe,
        mode   => 755
    }

    file {
        "/usr/local/scribe":
            ensure  => directory;

        "/var/rsi/logs/scribe":
            ensure  => directory;

        "/var/rsi/scribe":
            ensure  => directory;

        "/etc/init.d/neo-scribe":
            ensure  => absent;

        "/etc/logrotate.d/neo-scribe":
            ensure  => absent;

        "/etc/logrotate.d/scribe":
            owner    => 'root',
            group    => 'root',
            mode     => '644',
            source   => "puppet:///modules/scribe/scripts/scribe_logrotate";
 }
}

class scribe::service {

    service{

        "scribe":
                    ensure    => running,
#                    require   => Class["bidder::prod::config"],
                    hasstatus => true,
                    subscribe => File["/var/rsi/scribe/scribe.conf"];

  }
}

class scribe::repo {

 file {

        "/etc/yum.repos.d":
	    ensure   => directory,
            owner    => 'root',
            group    => 'root',
            mode     => '644',
            recurse => true,
            source   => "puppet://modules/scribe/repo";

 }

}
