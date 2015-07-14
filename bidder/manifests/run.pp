# Service module for bidder

class bidder::run {
    service{
        'tomcat':
                    ensure    => running,
                    require   => Class['bidder::config'],
                    hasstatus => true;
    }
}

