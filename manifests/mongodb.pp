stage { 
  'repos':      before => Stage['updates'];
  'updates':    before => Stage['packages'];
  'packages':   before => Stage['services'];
  'services':   before => Stage['main'];
}

class services {
  service {
    'mongodb':
      ensure => running,
      enable => true
  }
}

class repos {
  exec { 
    "get-mongo-key" :
      command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
      unless  => "/usr/bin/apt-key list| /bin/grep -c 10gen";
    "install-mongo-repo":
      command => "/bin/echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list",
      unless  => "/bin/grep 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart' -c /etc/apt/sources.list";
  }
}

class updates {
  # We must run apt-get update before we install our packaged because we installed some repo's
  exec { "apt-update":
    command => "/usr/bin/apt-get update -y -q",
    timeout => 0
  }
}

class packages {
  package {
    'mongodb-10gen': ensure => 'present';
  }
}

class {
  repos:      stage => "repos";
  updates:    stage => "updates";
  packages:   stage => "packages";
  services:   stage => "services";
}
