# scribe config details

class scribe::config {

    file {

        '/var/rsi/scribe/scribe.conf':
            mode   => '0444',
            owner  => scribe,
            group  => scribe,
            content => template('scribe/rtbbid_scribe_conf.erb');


        '/var/rsi/logs/scribe/buffer0':
            ensure => directory,
            mode   => '0755',
            owner  => scribe,
            group  => scribe;

        '/var/rsi/logs/scribe/buffer1':
            ensure => directory,
            mode   => '0755',
            owner  => scribe,
            group  => scribe;

        '/var/rsi/logs/scribe//perm0':
            ensure => directory,
            mode   => '0755',
            owner  => scribe,
            group  => scribe;

      }

    File {
        owner  => scribe,
        group  => scribe,
        mode   => 755
    }

    file {
        '/usr/local/scribe':
            ensure  => directory;

        '/var/rsi/logs/scribe':
            ensure  => directory;

        '/var/rsi/scribe':
            ensure  => directory;

        '/etc/init.d/neo-scribe':
            ensure  => absent;

        '/etc/logrotate.d/neo-scribe':
            ensure  => absent;

        '/etc/logrotate.d/scribe':
            owner    => 'root',
            group    => 'root',
            mode     => '0644',
            source   => 'puppet:///modules/scribe/scripts/scribe_logrotate';
  }
}

