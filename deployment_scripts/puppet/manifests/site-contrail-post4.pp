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

include contrail
$node_role = 'base-os'
# Deploy other nodes
if $contrail::node_name =~ /^contrail.\d+$/ {
  class { 'contrail::cfgm': } ->
  class { 'contrail::control': } ->
  class { 'contrail::analytics': } ->
  class { 'contrail::webui': } ->
  class {'contrail::provision':
    node_role => $node_role,
  }
}