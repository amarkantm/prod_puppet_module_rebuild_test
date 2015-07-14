# Config details for jdk module

class jdk::config {

    file {

        '/var/lib/java':
            ensure => directory,
            mode   => '0755';

        '/etc/bashrc.d/':
            ensure => directory,
            mode   => '0755';

        '/var/lib/java/dumps':
            ensure => directory,
            mode   => '1777';

        '/usr/bin/java':
            ensure  => link,
            target  => '/usr/java/default/bin/java';
#            require => Package["${package}"];

        '/usr/bin/jar':
            ensure  => link,
            target  => '/usr/java/default/bin/jar';
#            require => Package["${package}"];

        '/usr/bin/javac':
            ensure  => link,
            target  => '/usr/java/default/bin/javac';
#            require => Package["${package}"];

        '/usr/bin/jhat':
            ensure  => link,
            target  => '/usr/java/default/bin/jhat';
#            require => Package["${package}"];

        '/usr/bin/jmap':
            ensure  => link,
            target  => '/usr/java/default/bin/jmap';
#            require => Package["${package}"];

        '/usr/bin/jstat':
            ensure  => link,
            target  => '/usr/java/default/bin/jstat';
#            require => Package["${package}"];

  }
}

