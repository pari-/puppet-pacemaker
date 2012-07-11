class pacemaker::commit(
  $shadow_cib = $pacemaker::shadow_cib
) {
  file{"${pacemaker::cib_pool}/commit-cib":
    ensure  => present,
    content => template('pacemaker/commit.erb'),
  }

  exec{'commit-cib':
    path        => '/bin:/usr/sbin',
    command     => "sh ${pacemaker::cib_pool}/commit-cib",
    refreshonly => true,
    require     => File["${pacemaker::cib_pool}/commit-cib"],
  }

}
