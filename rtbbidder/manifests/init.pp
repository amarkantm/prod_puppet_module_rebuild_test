# == Class: rtbbidder
#
# Full description of class rtbbidder here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { rtbbidder:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name puppet@example.com
#
# === Copyright
#
# Copyright (C) 2015 Amar Kant
#
class rtbbidder {

#class { 'tomcat': 
#	require => Class["jdk"]
#}

#include scribe,
#	jdk,
#	tomcat, 
#f5_ltm,
  class{'repo': } ->
  class{'jdk::install': } ->
  class{'jdk::config': } ->
  class{'tomcat::users': } ->
  class{'tomcat::install': } ->
  class{'tomcat::config': } ->
  class{'bidder::config': } ->
  class{'bidder::run': } ->
  class{'scribe::users': } ->
  class{'scribe::install': } ->
  class{'scribe::config': } ->
  class{'scribe::run': } ->
#class{'ipprops': } ->
#class{"tomcat":} -> 
  Class[$name]
#	ipprops,
#	bidder
}
#class rtbbidder {

#  class{'repo': } ->
#  class{'jdk': } ->
#  class{'tomcat': } ->
#  class{'bidder': } ->
#  class{'scribe': } ->
#  Class[$name]

#}
