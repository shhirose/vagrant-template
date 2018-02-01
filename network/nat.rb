# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

DEFAULT_NAT_FORWARDED_PORT_PARAM = {
  'id' => '',
  'guest' => -1,
  'guest_ip' => nil,
  'host' => -1,
  'host_ip' => nil,
  'protocol' => 'tcp',
  'auto_correct' => false,
}

##
# Merge nat parameters and setting nat networks
#
def settingNatNetwork(config, yml)
  if yml['networks'].include?('nat_forwarded_ports')
    yml['networks']['nat_forwarded_ports'].each do |net|
      param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_NAT_FORWARDED_PORT_PARAM, net)

      if param['guest'].empty? || param['host'].empty?
        next
      end

      if param['protocol'].empty?
        param['protocol'] = 'tcp'
      end
      if param['id'].empty?
        param['id'] = param['protocol'] + param['guest']
      end

      config.vm.network "forwarded_port",
          id: param['id'],
          protocol: param['protocol'],
          guest: param['guest'],
          guest_ip: param['guest_ip'] || nil,
          host: param['host'],
          host_ip: param['host_ip'] || nil,
          auto_correct: param['auto_correct'] || false
    end
  end
end
