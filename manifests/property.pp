define pacemaker::property (
  $key,
  $value,
  $shadow_cib = $pacemaker::shadow_cib
) {
  include pacemaker

  file{"${pacemaker::cib_pool}/property-${name}":
    ensure  => present,
    content => template('pacemaker/property.erb'),
    notify  => Class['pacemaker::commit'],
  }

  exec{"property-${name}":
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/property-${name}",
    require     => File["${pacemaker::cib_pool}/property-${name}"],
  }
}

