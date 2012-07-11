define pacemaker::order (
  $score,
  $resources,
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/order-${name}":
    ensure  => present,
    content => template('pacemaker/order.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"order-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/order-${name}",
    require     => File["${pacemaker::cib_pool}/order-${name}"],
  }
}

