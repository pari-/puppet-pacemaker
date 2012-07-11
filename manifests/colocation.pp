define pacemaker::colocation (
  $score,
  $resources,
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/colocation-${name}":
    ensure  => present,
    content => template('pacemaker/colocation.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"colocation-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/colocation-${name}",
    require     => File["${pacemaker::cib_pool}/colocation-${name}"],
  }
}

