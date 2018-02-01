# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'vagrant/util/deep_merge'

def loadConfig(path)
  begin
    yml = YAML.load_file(File.join(File.dirname(__FILE__), '../' + path))
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
