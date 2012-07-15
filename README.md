puppet module for pacemaker
==========================

pacemaker is a High-Availability cluster resource manager for Heartbeat as well as Corosync.
This module will help you to setup pacemaker and maintain a proper CIB.

Basic usage
-----------

To install pacemaker:

<pre>
	include pacemaker
</pre>

or the parameterized form:

<pre>
	class {'pacemaker':
		corosync_config_pool => '/etc/corosync/service.d/',
	}
</pre>

Setup the CIB
------------------

The following code partly shows the introduction example you can find ''. It'll among other things setup an IPAddr2 resource, a shared DRBD device and basically handle some ordering and colocation constraints

<pre>
  pacemaker::create_new_cib{'create_new':
    before => Pacemaker::Node['hostA'],
  }

  pacemaker::node{'hostA':
    before     => Pacemaker::Node['hostB'],
  }

  pacemaker::node{'hostB':
    before     => Pacemaker::Property['ignore_quorum'],
  }

  pacemaker::property{'ignore_quorum':
    key        => 'no-quorum-policy',
    value      => 'ignore',
    before     => Pacemaker::Property['disable_stonith'],
  }

  pacemaker::property{'disable_stonith':
    key        => 'stonith-enabled',
    value      => false,
    before     => Pacemaker::Primitive['ClusterIP'],
  }

  pacemaker::primitive{'ClusterIP':
    provider   => 'ocf:heartbeat:IPaddr2',
    params     => 'ip=192.168.0.3 cidr_netmask=32',
    op         => 'monitor interval=15s',
    before     => Pacemaker::Primitive['SharedData'],
  }

  pacemaker::primitive{'SharedData':
    provider   => 'ocf:linbit:drbd',
    params     => 'drbd_resource=r0',
    op         => 'monitor interval=15s',
    before     => Pacemaker::Ms['SharedDataClone'],
  }

  pacemaker::ms{'SharedDataClone':
    rsc        => 'SharedData',
    meta       => 'master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true',
    before     => Pacemaker::Primitive['SharedFS'],
  }

  pacemaker::primitive{'SharedFS':
    provider   => 'ocf:heartbeat:Filesystem',
    params     => 'device="/dev/drbd/by-res/r0" directory="/mnt/drbd" fstype="ext4"',
    op         => 'monitor interval=15s',
    before     => Pacemaker::Colocation['fs_on_drbd'],
  }

  pacemaker::colocation{'fs_on_drbd':
    score      => 'inf',
    resources  => 'SharedFS SharedDataClone:Master',
    before     => Pacemaker::Order['SharedFS-after-SharedData'],
  }

  pacemaker::order{'SharedFS-after-SharedData':
    score      => 'inf',
    resources  => 'SharedDataClone:promote SharedFS:start',
    before     => Pacemaker::Colocation['FS-with-ip'],
  }

  pacemaker::colocation{'FS-with-ip':
    score      => 'inf',
    resources  => 'ClusterIP SharedFS',
    before     => Class['pacemaker::commit'],
  }

  class {'pacemaker::commit':}
</pre>

Caveats
-------

This module depends functionality-wise (at least partly) on my corosync module (in case of 'pacemaker_config_pool' != 'UNSET')

At first glance saving all cib components in the local fs seems to be sort of a show-stopper.
Yet, the idea behind it is simple: all changes to the CIB are supposed to be atomic, hence the usage of a shadow_cib.
Upon changes regarding Files, the eventual commit is triggered and therefor the update is performed properly.

If anyone has a cleaner approach, please let me know! :-)

Testreport
==========
Tested with Debian Squeeze 6.0.5 and pacemaker (=1.1.7-1~bpo60+1)


Copyright and License
---------------------

Copyright (C) 2012 Patrick Ringl <patrick_@freenet.de>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

