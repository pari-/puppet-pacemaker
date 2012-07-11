class pacemaker (
  $ensure                 = $pacemaker::params::ensure,
  $package                = $pacemaker::params::package,
  $auto_upgrade           = $pacemaker::params::auto_upgrade,
  $conf_dir               = $pacemaker::params::conf_dir,
  $cib_pool               = $pacemaker::params::cib_pool,
  $corosync_config_pool  = 'UNSET',
  $shadow_cib             = $pacemaker::params::shadow_cib
) inherits pacemaker::params {

  class {'pacemaker::package':}
  class {'pacemaker::config':}

  if $ensure == 'present' {
    Class['pacemaker::package'] -> Class['pacemaker::config']
  }

}
