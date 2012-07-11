define pacemaker::create_new_cib (
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/cib-${name}":
    ensure  => present,
    content => template('pacemaker/cib.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"create_new_cib-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/cib-${name}",
    require     => File["${pacemaker::cib_pool}/cib-${name}"],
  }

}

