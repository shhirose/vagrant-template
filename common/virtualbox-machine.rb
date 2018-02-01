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

def mergeVirtualMachineParams(config, yml)
  param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_VIRTUAL_MACHINE_PARAM, yml)

  return param
end

def settingVitrualMachine(config, yml)
  if isNotHashEmpty(yml, 'box_name')
    config.vm.box = yml['box_name']
  end
  if isNotHashEmpty(yml, 'box_url')
    config.vm.box_url = yml['box_url']
  end
end
