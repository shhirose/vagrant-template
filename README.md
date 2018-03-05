# Vagrantfile template


```
---
spec: &__spec
  cpu: 1
  memory: 1024

synced_folders: &__synced_folders
  - host: '../../Ansible/ansible-galaxy/roles/shhirose.motd/'
    guest: '/tmp/ansible-motd/'
    owner: root
    group: root
    create: true

provider: &__redhat_provider
  virtualbox:
    box_check_update: true
    gui: false
    modifyvm:
      ostype: 'RedHat_64'

provider: &__debian_provider
  virtualbox:
    box_check_update: true
    gui: false
    modifyvm:
      ostype: 'Debian_64'

provider: &__ubuntu_provider
  virtualbox:
    box_check_update: true
    gui: false
    modifyvm:
      ostype: 'Ubuntu_64'


provider: virtualbox
vm:
  vms:
    centos7:
      box_name: centos/7
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__redhat_provider
    centos6:
      box_name: centos/6
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__redhat_provider
    debian8:
      box_name: debian/jessie64  # EOL - 2020/4/30
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__debian_provider
    debian9:
      box_name: debian/stretch64  # EOL - 2022
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__debian_provider
    ubuntu1404:
      box_name: ubuntu/trusty64  # EOL - 2019/04/30
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__ubuntu_provider
    ubuntu1604:
      box_name: ubuntu/xenial64  # EOL - 2021/04/30
      <<: *__spec
      synced_folders: *__synced_folders
      provider: *__ubuntu_provider
```
