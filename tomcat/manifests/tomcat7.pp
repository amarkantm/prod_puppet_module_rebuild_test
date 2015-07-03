
#####
# This module handles installing of
# asci-tomcat7
# 
# by default we install latest asci-tomcat7 rpm
# otherwise we accept specific versions
#####

class tomcat7($package='tomcat-7.0.33') {

# Ensure /etc/passwd exists

  file { '/etc/passwd':
    	    ensure => 'file',
    	    owner  => 'root',
    	    group  => 'root',
    	    mode   => '0644';

        '/home/tomcat':
            ensure => directory,
            mode   => '0700';

        '/home/tomcat/.ssh':
            ensure => directory,
            mode   => '0700';

}

# Create tomcat user

  user { 'tomcat':
      ensure   => 'present',
      comment  => 'tomcat user',
      gid      => '1003',
      managehome => true,
      home     => '/home/tomcat',
      shell    => '/bin/bash',
      uid      => '1003',
      require  => File['/etc/passwd'],
    }

  group { 'tomcat':
        ensure   => 'present',
        gid      => '1003',
    }

  user { 'as':
      ensure   => 'present',
      comment  => 'as user',
      gid      => '1000',
      managehome => true,
      home     => '/home/as',
      groups   => [ 'as', 'tomcat' ],
      shell    => '/bin/bash',
      uid      => '1000',
      require  => File['/etc/passwd'],
    }

  group { 'as':
        ensure   => 'present',
        gid      => '1000',
    }


#    Asci_users::Pupuser <| title == tomcat |>

    $init_array = ['/etc/rc0.d/K87tomcat',
          	   '/etc/rc2.d/S98tomcat',
                   '/etc/rc2.d/K87tomcat',
                   '/etc/rc3.d/S98tomcat',
                   '/etc/rc3.d/K87tomcat',
                   '/etc/rc4.d/S98tomcat',
                   '/etc/rc4.d/K87tomcat',
                   '/etc/rc5.d/S98tomcat',
                   '/etc/rc5.d/K87tomcat',
                   '/etc/rc6.d/K87tomcat']

    package {
        $package:
            ensure => present
    }


    File {
        owner => tomcat,
        group => tomcat
    }

    file {

        '/var/lib/tomcat':
            ensure => directory,
            mode   => '0775';

        '/var/lib/tomcat/dumps':
            ensure => directory,
            mode   => '0775';

###
# Commented this.  We _need_
# to move all logging to /var/rsi/logs
# and sym link /logs -> /var/rsi/logs
#
# Every BGAS server neesd to be changed
# which is a big committment for a Friday afternoon
# CEH - 2/10/12
##

#        "/logs/tomcat":
#           ensure => directory,
#            mode   => 775;

        '/var/rsi':
            ensure => directory,
            owner  => 'as',
	    group  => 'as',
            mode   => '4775';

        '/var/rsi/tomcat':
            ensure => directory,
            mode   => '4775';

        '/var/rsi/tomcat/tmp':
            ensure => directory,
            mode   => '4775';

        '/var/rsi/tomcat/work':
            ensure => directory,
            mode   => '4775';

        '/var/rsi/tomcat/webapps':
            ensure => directory,
            mode   => '4775';

        '/var/rsi/tomcat/jars':
            ensure => directory,
            mode   => '4775';

        '/usr/local/tomcat':
            ensure  => directory,
            recurse => true,
            owner   => 'tomcat',
            group   => 'tomcat';

        '/usr/local/tomcat/conf':
            ensure  => directory,
            recurse => true,
            owner   => 'tomcat',
            group   => 'tomcat';

        '/usr/local/tomcat/bin':
            ensure  => directory,
            recurse => true,
            owner   => 'tomcat',
            group   => 'tomcat';

        $init_array:
            mode   => '0755',
            ensure => link,
            target => '/etc/init.d/tomcat';
    }
}
