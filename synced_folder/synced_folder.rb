# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

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

##
#
#
# @param config
# @param yaml
#
def settingSyncedFolder(config, yml)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  if yml.has_key?('synced_folder') && yml['synced_folder'].is_a?(Hash)
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
