define pacemaker::node (
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/node-${name}":
    ensure  => present,
    content => template('pacemaker/node.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"node-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/node-${name}",
    require     => File["${pacemaker::cib_pool}/node-${name}"],
  }
}

