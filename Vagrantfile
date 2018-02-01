# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'vagrant/util/deep_merge'
require './common/utils'
require './common/common-machine'
#require './common/virtualbox-machine'
require './network/nat'
require './network/private'
require './network/public'
require './synced_folder/synced_folder'
require './provider/virtualbox'

Vagrant.configure("2") do |config|
  yml = loadConfig('config.yml')

  settingCommon(config, yml['vm'])

  # Setting Guest OS
  yml['vm']['vms'].each do |name, conf|
    config.vm.define name do |vm|
      #param = mergeVirtualMachineParams(vm, conf)

      #settingVitrualMachine(vm, param)

      # Setting provider for VirtualBox. See provider/virtualbox.rb
      settingProviderVirtualBox(vm, conf)

      # Setting nat network. See network/nat.rb
      settingNatNetwork(vm, conf)

      # Setting private network. See network/private.rb
      settingPrivateNetworks(vm, conf)

      # Setting public network. See network/public.rb
      settingPublicNetworks(vm, conf)

      # Setting synced folder. See synced_folder/synced_folder.rb
      settingSyncedFolder(vm, conf)
    end
  end
end
