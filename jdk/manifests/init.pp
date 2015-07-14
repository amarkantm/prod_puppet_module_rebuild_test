######
## This module handles installing of
## java jdk 1.8u40
######
class jdk {

  class{'jdk::install': } ->
  class{'jdk::config': } ->
  Class[$name]

}
