class profiles::nodejs {

    exec { 'add_nodesource_repo':
      command => '/usr/bin/curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -',
      path    => ['/usr/bin', '/bin'],
      unless  => '/usr/bin/yum repolist all | grep nodesource',
    }

    package { 'nodejs':
      ensure  => installed,
      require => Exec['add_nodesource_repo'],

    }
}
