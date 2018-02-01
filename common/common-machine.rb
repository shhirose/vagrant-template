# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'
require './common/utils'

DEFAULT_COMMON_PARAM = {
  'box_name' => nil,
  'box_url' => nil
}

def settingCommon(config, yml)
  param = Vagrant::Util::DeepMerge.deep_merge(DEFAULT_COMMON_PARAM, yml)

  if isNotHashEmpty(param, 'box_name')
    config.vm.box = param['box_name']
  end
  if isNotHashEmpty(param, 'box_url')
    config.vm.box_url = param['box_url']
  end
end
