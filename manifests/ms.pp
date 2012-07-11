define pacemaker::ms (
  $rsc,
  $meta,
  $shadow_cib = $pacemaker::shadow_cib
) {

  include pacemaker

  file{"${pacemaker::cib_pool}/ms-${name}":
    ensure  => present,
    content => template('pacemaker/ms.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"ms-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/ms-${name}",
    require     => File["${pacemaker::cib_pool}/ms-${name}"],
  }


}

