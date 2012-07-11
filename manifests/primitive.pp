define pacemaker::primitive (
  $provider,
  $params,
  $op,
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/primitive-${name}":
    ensure  => present,
    content => template('pacemaker/primitive.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"primitive-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/primitive-${name}",
    require     => File["${pacemaker::cib_pool}/primitive-${name}"],
  }
}

