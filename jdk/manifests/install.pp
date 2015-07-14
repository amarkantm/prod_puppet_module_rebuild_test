# Jdk intallation module
class jdk::install {

    package {
        'jdk1.8.0_40.x86_64':
            ensure   => present,
    }
}
