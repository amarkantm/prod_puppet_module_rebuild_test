# Run scribe service

class scribe::run {

    service{

        'scribe':
                    ensure    => running,
                    require   => Class['bidder::config'],
                    hasstatus => true,
                    subscribe => File['/var/rsi/scribe/scribe.conf'];

  }
}

