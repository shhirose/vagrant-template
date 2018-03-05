# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

DEFAULT_COMMON_PARAM = {
  'box_name' => nil,
  'box_url' => nil
}
DEFAULT_NAT_FORWARDED_PORT_PARAM = {
  'id' => '',
  'guest' => -1,
  'guest_ip' => nil,
  'host' => -1,
  'host_ip' => nil,
  'protocol' => 'tcp',
  'auto_correct' => false,
}
DEFAULT_PRIVATE_NETWORK_PARAM = {
  'dhcp' => true,
  'dhcp_lower' => nil,
  'dhcp_upper' => nil,
  'ip_addr' => '',
  'netmask' => '24',
  'auto_config' => true,
  'name' => nil,
}
DEFAULT_PUBLIC_NETWORK_PARAM = {
  'dhcp' => true,
  'dhcp_assigned_default_route' => false,
  'ip_addr' => '',
  'netmask' => '255.255.255.0',
  'bridge' => [],
  'auto_config' => true,
}
DEFAULT_SYNCED_FOLDER = {
  'id' => nil,
  'type' => 'virtualbox',
  'host' => '.',
  'guest' =>  '/vagrant',
  'create' => false,
  'owner' => 'vagrant',
  'group' => 'vagrant',
  'mount_options' => [],
  'disabled' => false,

  'nfs_export' => true,
  'nfs_udp' => true,
  'nfs_version' => 3,

  'rsync__args' => [],
  'rsync__auto' => true,
  'rsync__chown' => true,
  'rsync__exclude' => [],
  'rsync__rsync_path' => nil,
  'rsync__verbose' => false,

  'smb_host' => nil,
  'smb_password' => nil,
  'smb_username' => nil
}
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

def loadConfig(path)
  begin
    yml = YAML.load_file(File.join(File.dirname(__FILE__), './' + path))
    unless yml
      yml = { }
    end
  rescue Errno::ENOENT => ex
    yml = { }
  end

  return yml
end

def isHashEmpty(obj, key)
  if obj.kind_of?(Hash) == false
    return true
  elsif obj.has_key?(key) == false
    return true
  elsif obj[key].nil? || obj[key].empty?
    return true
  end

  return false
end

def isNotHashEmpty(obj, key)
  return isHashEmpty(obj, key) == false
end

def settingCommon(config, yml)
  param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_COMMON_PARAM, yml)

  if isNotHashEmpty(param, 'box_name')
    config.vm.box = param['box_name']
  end
  if isNotHashEmpty(param, 'box_url')
    config.vm.box_url = param['box_url']
  end
  if isNotHashEmpty(param, 'ssh')
    if isNotHashEmpty(param['ssh'], 'username')
      config.ssh.username = param['ssh']['username']
    end
    if isNotHashEmpty(param['ssh'], 'password')
      config.ssh.password = param['ssh']['password']
    end
    if isNotHashEmpty(param['ssh'], 'host')
      config.ssh.host = param['ssh']['host']
    end
    if isNotHashEmpty(param['ssh'], 'port')
      config.ssh.port = param['ssh']['port']
    end
    if isNotHashEmpty(param['ssh'], 'guest_port')
      config.ssh.guest_port = param['ssh']['guest_port']
    end
    if isNotHashEmpty(param['ssh'], 'private_key_path')
      config.ssh.private_key_path = param['ssh']['private_key_path']
    end
    if isNotHashEmpty(param['ssh'], 'keys_only')
      config.ssh.keys_only = param['ssh']['keys_only']
    end
    if isNotHashEmpty(param['ssh'], 'paranoid')
      config.ssh.paranoid = param['ssh']['paranoid']
    end
    if isNotHashEmpty(param['ssh'], 'forward_agent')
      config.ssh.forward_agent = param['ssh']['forward_agent']
    end
    if isNotHashEmpty(param['ssh'], 'forward_x11')
      config.ssh.forward_x11 = param['ssh']['forward_x11']
    end
    if isNotHashEmpty(param['ssh'], 'forward_env')
      config.ssh.forward_env = param['ssh']['forward_env']
    end
    if isNotHashEmpty(param['ssh'], 'insert_key')
      config.ssh.insert_key = param['ssh']['insert_key']
    end
    if isNotHashEmpty(param['ssh'], 'proxy_command')
      config.ssh.proxy_command = param['ssh']['proxy_command']
    end
    if isNotHashEmpty(param['ssh'], 'pty')
      config.ssh.pty = param['ssh']['pty']
    end
    if isNotHashEmpty(param['ssh'], 'keep_alive')
      config.ssh.keep_alive = param['ssh']['keep_alive']
    end
    if isNotHashEmpty(param['ssh'], 'shell')
      config.ssh.shell = param['ssh']['shell']
    end
    if isNotHashEmpty(param['ssh'], 'export_command_template')
      config.ssh.export_command_template = param['ssh']['export_command_template']
    end
    if isNotHashEmpty(param['ssh'], 'sudo_command')
      config.ssh.sudo_command = param['ssh']['sudo_command']
    end
    if isNotHashEmpty(param['ssh'], 'compression')
      config.ssh.compression = param['ssh']['compression']
    end
    if isNotHashEmpty(param['ssh'], 'dsa_authentication')
      config.ssh.dsa_authentication = param['ssh']['dsa_authentication']
    end
    if isNotHashEmpty(param['ssh'], 'extra_args')
      config.ssh.extra_args = param['ssh']['extra_args']
    end
  end
end

##
# Merge nat parameters and setting nat networks
#
def settingNatNetwork(config, yml)
  if isNotHashEmpty(yml, 'networks') && yml['networks'].include?('nat_forwarded_ports')
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

##
# Merge nat parameters and setting nat networks
#
def settingPrivateNetworks(config, yml)
  if isNotHashEmpty(yml, 'networks') && yml['networks'].include?('privates')
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

##
# Merge nat parameters and setting nat networks
#
def settingPublicNetworks(config, yml)
  if isNotHashEmpty(yml, 'networks') && yml['networks'].include?('publics')
    yml['networks']['publics'].each do |net|
      param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_PUBLIC_NETWORK_PARAM, net)

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

##
#
#
# @param config
# @param yaml
#
def settingSyncedFolder(config, yml)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  if yml.has_key?('synced_folders') && yml['synced_folders'].is_a?(Array)
    yml['synced_folders'].each do |folder|
      param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_SYNCED_FOLDER, folder)

      case param['type']
      when 'nfs' then
        config.vm.synced_folder param['host'], param['guest'],
            type: 'nfs',
            id: param['id'] || nil,
            create: param['create'] || false,
            owner: param['owner'] || 'vagrant',
            group: param['group'] || 'vagrant',
            mount_options: param['mount_options'] || nil,
            disabled: param['disabled'] || false,
            nfs_export: param['nfs_export'] || true,
            nfs_udp: param['nfs_udp'] || true,
            nfs_version: param['nfs_version']
      when 'rsync' then
        config.vm.synced_folder param['host'], param['guest'],
            type: 'rsync',
            id: param['id'] || nil,
            create: param['create'] || false,
            owner: param['owner'] || 'vagrant',
            group: param['group'] || 'vagrant',
            mount_options: param['mount_options'] || nil,
            disabled: param['disabled'] || false,
            rsync__args: param['rsync__args'] || nil,
            rsync__auto: param['rsync__auto'] || true,
            rsync__chown: param['rsync__chown'] || true,
            rsync__exclude: param['rsync__exclude'] || nil,
            rsync__rsync_path: param['rsync__rsync_path'] || nil,
            rsync__verbose: param['rsync__verbose'] || false
      when 'smb' then
        config.vm.synced_folder param['host'], param['guest'],
            type: 'smb',
            id: param['id'] || nil,
            create: param['create'] || false,
            owner: param['owner'] || 'vagrant',
            group: param['group'] || 'vagrant',
            mount_options: param['mount_options'] || nil,
            disabled: param['disabled'] || false,
            smb_host: param['smb_host'] || nil,
            smb_password: param['smb_password'] || nil,
            smb_username: param['smb_username'] || nil
      else
        config.vm.synced_folder param['host'], param['guest'],
            type: 'virtualbox',
            id: param['id'] || nil,
            create: param['create'] || false,
            owner: param['owner'] || 'vagrant',
            group: param['group'] || 'vagrant',
            mount_options: param['mount_options'] || nil,
            disabled: param['disabled'] || false
      end
    end
  end
end

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

Vagrant.configure("2") do |config|
  yml = loadConfig('config.yml')

  settingCommon(config, yml['vm'])

  # Setting Guest OS
  yml['vm']['vms'].each do |name, conf|
    config.vm.define name do |vm|
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
