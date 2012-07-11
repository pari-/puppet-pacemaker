class pacemaker::config {
  if $pacemaker::corosync_config_pool != 'UNSET' {
    file {"${pacemaker::corosync_config_pool}/pcmk":
      ensure => present,
      source => 'puppet:///modules/pacemaker/pcmk',
      notify => Class['corosync::service'],
    }
  }

  file {$pacemaker::cib_pool:
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    require => File[$pacemaker::conf_dir],
  }

  file {$pacemaker::conf_dir:
    ensure  => 'directory',
    purge   => true,
    recurse => true,
  }

}

