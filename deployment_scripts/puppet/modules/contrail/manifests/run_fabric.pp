#    Copyright 2015 Mirantis, Inc.
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

# A helper to run fabric
define contrail::run_fabric (
  $hostgroup = undef,
  $taskname = $name,
  $command = undef,
) {
  Exec {
    cwd => '/opt/contrail/utils',
    path => '/bin:/usr/bin:/usr/local/bin',
    logoutput => true,
    creates => "/opt/contrail/${taskname}-DONE"
  }
  case $hostgroup {
    control: {
      exec { "Run-fabric-command-on-${hostgroup}":
        command => "fab --show debug -P -R ${hostgroup} -- '${command}' && touch /opt/contrail/${taskname}-DONE",
      }
    }
    default: {
      exec { "Run-local-fabric-task-${taskname}":
        command => "fab --show debug ${taskname} && touch /opt/contrail/${taskname}-DONE",
      }
    }
  }
}