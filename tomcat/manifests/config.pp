# tomcat config details

class tomcat::config {

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

##
# Commented this.  We _need_
# to move all logging to /var/rsi/logs
# and sym link /logs -> /var/rsi/logs
#
# Every BGAS server neesd to be changed
# which is a big committment for a Friday afternoon
# CEH - 2/10/12
#

#        "/logs/tomcat":
#           ensure => directory,
#            mode   => 775;

        '/var/rsi':
            ensure => directory,
            owner  => 'as',
            group  => 'as',
            mode   => '4775';

        '/var/rsi/run':
            ensure => directory,
            owner  => 'as',
            group  => 'as',
            mode   => '4775';

        '/var/rsi/run/tomcat':
            ensure => directory,
            owner  => 'tomcat',
            group  => 'tomcat',
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

        '/usr/local/tomcat-7.0.30-stable':
            ensure  => directory,
            recurse => true,
            owner   => 'tomcat',
            group   => 'tomcat';

        '/usr/local/tomcat':
            ensure => link,
      mode   => '0777',
            target => '/usr/local/tomcat-7.0.30-stable';

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
      ensure => link,
            mode   => '0755',
            target => '/etc/init.d/tomcat';

        '/var/rsi/logs/':
            ensure => directory,
            mode   => '0775',
            owner  => 'as',
            group  => 'as';

        '/usr/local/tomcat/bin/setenv.sh':
            mode   => '0755',
            content => template('tomcat/setenv.erb'),
            owner  => tomcat,
            group  => tomcat;

        '/usr/local/tomcat/conf/web.xml':
            mode   => '0644',
            source => 'puppet:///modules/tomcat/tomcat/web.xml',
            owner  => tomcat,
            group  => tomcat;

        '/etc/init.d/tomcat':
            owner  => root,
            group  => root,
            mode   => '0755',
            source => 'puppet:///modules/tomcat/tomcat/tomcat_init';

        '/usr/local/tomcat/bin/nodeStatus.pl':
            owner  => tomcat,
            group  => tomcat,
            mode   => '0755',
            source => 'puppet:///modules/tomcat/tomcat/nodeStatus.pl';


    }
}

