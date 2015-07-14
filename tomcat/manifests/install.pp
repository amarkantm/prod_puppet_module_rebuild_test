# Install tomcat

class tomcat::install($package='tomcat.x86_64') {

    package {
        $package:
            ensure => present,
    }
}
