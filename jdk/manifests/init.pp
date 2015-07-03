#####
# This module handles installing of
# java jdk 1.8u45
#####

class jdk::jdk8u45 {
    class {
        "jdk_install":
            package => 'jdk-8u45-linux-i586.rpm',
    }
}

class jdk {

include jdk::jdk8u45

}
