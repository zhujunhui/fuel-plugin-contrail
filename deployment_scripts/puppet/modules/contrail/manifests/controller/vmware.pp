#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

class contrail::controller::vmware {

  if $contrail::use_vcenter {
    
    $pkgs = ['contrail-fabric-utils','contrail-setup']
    $pip_pkgs = ['Fabric-1.7.5']

    class { 'contrail::package':
      install     => $pkgs,
      pip_install => $pip_pkgs,
    } ->
    exec {'retrive install packages':
      command => "/usr/bin/curl -fLO http://${::contrail::master_ip}:8080/plugins/contrail-3.0/latest-contrail-install-packages.deb",
      creates => '/opt/contrail/contrail-install-packages.deb',
      cwd     => '/opt/contrail'
    } ->

    exec {'retrive vmware plugin packages':
      command => "/usr/bin/curl -fLO http://${::contrail::master_ip}:8080/plugins/contrail-3.0/latest-contrail-install-vcenter-plugin.deb",
      creates => '/opt/contrail/contrail-install-vcenter-plugin.deb',
      cwd     => '/opt/contrail'
    } ->

    exec {'retrive vmdk':
      command => "/usr/bin/curl -fLO http://${::contrail::master_ip}:8080/plugins/contrail-3.0/ContrailVM-disk1.vmdk",
      creates => '/opt/contrail/ContrailVM-disk1.vmdk',
      cwd     => '/opt/contrail'
    } ->

    file { '/opt/contrail/utils/fabfile/testbeds/testbed.py':
      content => template('contrail/vmware_testbed.py.erb'),
    }
  }
}
