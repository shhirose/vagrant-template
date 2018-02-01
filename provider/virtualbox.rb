# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

DEFAULT_VIRTUAL_MACHINE_PARAM = {
  'box_name' => nil,
  'box_url' => nil,
  'vm_name' => nil,
  'cpu' => 1,
  'memory' => 512,
  'hostname' => nil,
  'synced_folder' => [],
  'networks' => [],
  'provider' => []
}

##
#
#
# @param configure
# @param yml
#
def settingProviderVirtualBox(config, yml)
  param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_VIRTUAL_MACHINE_PARAM, yml)

  if isNotHashEmpty(yml, 'box_name')
    config.vm.box = yml['box_name']
  end
  if isNotHashEmpty(yml, 'box_url')
    config.vm.box_url = yml['box_url']
  end
  if isNotHashEmpty(yml, 'hostname')
    config.vm.hostname = yml['hostname']
  end

  config.vm.provider :virtualbox do |v|
    # Guest VM name of VirtualBox
    if yml['vm_name'].nil? == false && yml['vm_name'].empty? == false
      v.name = yml['vm_name']
    end

    # The number of CPU of guest VM
    v.cpus = yml['cpu'] || 1

    # The number of Memory (MB) of guest VM
    v.memory = yml['memory'] || 512

    if yml['provider'].has_key?('virtualbox')
      provider = yml['provider']['virtualbox']
      # View VirtualBox GUI
      v.gui = provider['gui'] || false

      # Set architecture of guest VM
      (provider['modifyvm'] || []).each do |key, type|
        v.customize ["modifyvm", :id, '--' + key, type]
      end
    end
  end
end
