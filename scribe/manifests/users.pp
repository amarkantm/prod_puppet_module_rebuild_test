# create scribe user

class scribe::users {

# Ensure /etc/passwd exists

#  file { '/etc/passwd':
#    ensure => 'file',
#    owner  => 'root',
#    group  => 'root',
#    mode   => '0644',
#}

  user { 'scribe':
      ensure     => 'present',
      comment    => 'scribe user',
      gid        => '413',
      managehome => true,
      home       => '/home/scribe',
      shell      => '/bin/bash',
      uid        => '413',
      require    => File['/etc/passwd'],
    }

  group { 'scribe':
        ensure => 'present',
        gid    => '413',
    }
}
