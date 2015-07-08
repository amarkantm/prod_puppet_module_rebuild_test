#####
# This module handles installing of
# java jdk 1.8u45
#####

#class jdk::install {

#    package {
#        "jdk":
#            ensure   => present,
#    }
#}

class jdk::jdk6u45 {
    class {
        "jdk_install":
            package => 'jdk-6u45-linux-i586.rpm',
    }
}



class jdk {

include jdk::jdk8u45

}
