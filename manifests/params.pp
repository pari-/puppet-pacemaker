class pacemaker::params {
  $ensure = 'present'
  $auto_upgrade = false
  $shadow_cib = 'tmp'

  case $::operatingsystem {
    'Debian': {
      $package = [ 'pacemaker' ]
      $conf_dir = '/etc/pacemaker.d'
      $cib_pool = "${conf_dir}/cib"
    }
    default: {
      fail("\"${module_name}\" is not supported on \"${::operatingsystem}\"")
    }
  }

}
