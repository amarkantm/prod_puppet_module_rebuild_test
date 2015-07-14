# Add users for tomcat module

class tomcat::users {

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

        '/home/tomcat/.ssh/config':
            owner   => tomcat,
            group   => tomcat,
            mode    => '0644',
            content => "Host *\n\tStrictHostKeyChecking no\n"
}

# Create tomcat user

  user { 'tomcat':
      ensure     => 'present',
      comment    => 'tomcat user',
      gid        => '1003',
      managehome => true,
      home       => '/home/tomcat',
      shell      => '/bin/bash',
      uid        => '1003',
      require    => File['/etc/passwd'],
    }

  group { 'tomcat':
        ensure => 'present',
        gid    => '1003',
    }

# Create as user

  user { 'as':
      ensure     => 'present',
      comment    => 'as user',
      gid        => '1000',
      managehome => true,
      home       => '/home/as',
      groups     => [ 'as', 'tomcat' ],
      shell      => '/bin/bash',
      uid        => '1000',
      require    => File['/etc/passwd'],
    }

  group { 'as':
        ensure => 'present',
        gid    => '1000',
    }
}
