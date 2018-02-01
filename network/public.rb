# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

DEFAULT_PUBLIC_NETWORK_PARAM = {
  'dhcp' => true,
  'dhcp_assigned_default_route' => false,
  'ip_addr' => '',
  'netmask' => '255.255.255.0',
  'bridge' => [],
  'auto_config' => true,
}

##
# Merge nat parameters and setting nat networks
#
def settingPublicNetworks(config, yml)
  if yml['networks'].include?('publics')
    yml['networks']['publics'].each do |net|
      param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_PUBLIC_NETWORK_PARAM, net)

      if param['ip_addr'].empty?
        param['dhcp'] = true
      end

      if net['dhcp']
        if param['dhcp_lower'].empty?
          param['dhcp_lower'] = nil
        end
        if param['dhcp_upper'].empty?
          param['dhcp_upper'] = nil
        end

        config.vm.network "public_network",
            type: 'dhcp',
            dhcp_lower: param['dhcp_lower'],
            dhcp_upper: param['dhcp_upper'],
            use_dhcp_assigned_default_route: param['use_dhcp_assigned_default_route'],
            auto_config: param['auto_config'],
            bridge: param['bridge'] || nil
      else
        config.vm.network "public_network",
            ip: param['ip_addr'],
            netmask: param['netmask'],
            virtualbox__intnet: param['name'],
            auto_config: param['auto_config'],
            bridge: param['bridge'] || nil
      end
    end
  end
end
