class stack_puppet (

  $ensure                           = 'present',

  $puppet_install                   = false,
  $puppet_run_mode                  = 'manual',
  $puppet_config_template           = 'stack_puppet/puppet/puppet.conf',
  $puppet_config_hash               = { },

  $puppetdb_install                 = false,
  $puppetdb_config_template         = 'stack_puppet/puppetdb/puppetdb.conf',
  $puppetdb_config_hash             = { },

  $postgresql_install               = false,
  $postgresql_config_template       = 'stack_puppet/postgresql/postgresql.conf',
  $postgresql_config_hash           = { },

  $puppetmaster_install             = false,
  $puppetmaster_proxy               = 'passenger',
  $puppetmaster_config_template     = 'stack_puppet/puppetmaster/puppet.conf',
  $puppetmaster_config_hash         = { },

  $mcollective_install              = false,
  $mcollective_config_template      = 'stack_puppet/mcollective/mcollective.conf',
  $mcollective_config_hash          = { },

  $activemq_install                 = false,
  $activemq_config_template         = 'stack_puppet/activemq/activemq.conf',
  $activemq_config_hash             = { },

  $mco_install                      = false,
  $mco_config_template              = 'stack_puppet/mco/mco.conf',
  $mco_config_hash                  = { },

  $mysql_install                    = false,
  $mysql_config_template            = '',
  $mysql_config_hash                = { },

  $foreman_install                  = false,
  $foreman_config_template          = 'stack_puppet/foreman/foreman.conf',
  $foreman_config_hash              = { },

  $foremanproxy_install             = false,
  $foremanproxy_config_template     = 'stack_puppet/foremanproxy/foremanproxy.conf',
  $foremanproxy_config_hash         = { },

  $puppetdashboard_install          = false,
  $puppetdashboard_config_template  = 'stack_puppet/puppetdashboard/puppetdashboard.conf',
  $puppetdashboard_config_hash      = { },

  ) {

  $puppetmaster_servers = query_nodes('Class[puppet::server]')
  $puppetmaster_servers_ip = query_nodes('Class[puppet::server]', ipaddress)


  $puppetdb_servers = query_nodes('Class[puppetdb]')
  $puppetdb_servers_ip = query_nodes('Class[puppetdb', ipaddress)

  # TOFIX: More robust real (and only) puppet related activemq servers recognition
  $activemq_servers = query_nodes('Class[activemq]')
  $activemq_servers_ip = query_nodes('Class[activemq', ipaddress)

  $foremanproxy_servers = query_nodes('Class[foremanproxy]')
  $foremanproxy_servers_ip = query_nodes('Class[foremanproxy]' ipaddress)

  # TOFIX: Review inclusion logic to allow proper removal of previously declared classes
  if $puppet_install {
    class { 'puppet':
      run_mode      => $puppet_run_mode,
      template      => $puppet_config_template,
    }
  }

  # TOFIX: Decide if and how to expose credentials params
  if $mcollective_install {
    class { 'mcollective':
      template      => $mcollective_config_template,
      stomp_host           => $activemq_servers,
      stomp_user           => 'mcollective',
      stomp_password       => 'private_server',
      stomp_admin          => 'admin',
      stomp_admin_password => 'private_client',
      psk                  => 'aSecretPreSharedKey',
    }
  }

  if $puppetdb_install {
    class { 'puppetdb':
      db_type      => 'postgresql',
      db_host      => '127.0.0.1',
    }
  }

  if $foreman_install {
    class { 'foreman':
      db_type      => 'postgresql',
      db_host      => '127.0.0.1',
    }
  }

}
