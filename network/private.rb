# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

DEFAULT_PRIVATE_NETWORK_PARAM = {
  'dhcp' => true,
  'dhcp_lower' => nil,
  'dhcp_upper' => nil,
  'ip_addr' => '',
  'netmask' => '24',
  'auto_config' => true,
  'name' => nil,
}

##
# Merge nat parameters and setting nat networks
#
def settingPrivateNetworks(config, yml)
  if yml['networks'].include?('privates')
    yml['networks']['privates'].each do |net|
      param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_PRIVATE_NETWORK_PARAM, net)

      if param['ip_addr'].empty?
        param['dhcp'] = true
      end

      if net['dhcp']
        if (not param['dhcp_lower'].nil?) && param['dhcp_lower'].empty?
          param['dhcp_lower'] = nil
        end
        if (not param['dhcp_upper'].nil?) && param['dhcp_upper'].empty?
          param['dhcp_upper'] = nil
        end

        config.vm.network "private_network",
            type: 'dhcp',
            dhcp_lower: param['dhcp_lower'],
            dhcp_upper: param['dhcp_upper'],
            auto_config: param['auto_config']
      else
        if param['intnet'].empty?
          param['intnet'] = nil
        end

        config.vm.network "private_network",
            ip: param['ip_addr'],
            netmask: param['netmask'],
            virtualbox__intnet: param['intnet'],
            auto_config: param['auto_config']
      end
    end
  end
end
