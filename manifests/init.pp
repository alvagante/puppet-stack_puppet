class stack_puppet (

  $ensure                           = 'present',

  $puppet_install                   = false,
  $puppet_run_mode                  = 'manual',
  $puppet_config_template           = 'stack_puppet/puppet/puppet.conf',
  $puppet_options_hash               = { },

  $puppetdb_install                 = false,
  $puppetdb_config_template         = 'stack_puppet/puppetdb/puppetdb.conf',
  $puppetdb_options_hash             = { },

  $postgresql_install               = false,
  $postgresql_config_template       = 'stack_puppet/postgresql/postgresql.conf',
  $postgresql_options_hash           = { },

  $puppetmaster_install             = false,
  $puppetmaster_proxy               = 'passenger',
  $puppetmaster_config_template     = 'stack_puppet/puppetmaster/puppet.conf',
  $puppetmaster_options_hash         = { },

  $mcollective_install              = false,
  $mcollective_config_template      = 'stack_puppet/mcollective/mcollective.conf',
  $mcollective_options_hash          = { },

  $activemq_install                 = false,
  $activemq_config_template         = 'stack_puppet/activemq/activemq.conf',
  $activemq_options_hash             = { },

  $mco_install                      = false,
  $mco_config_template              = 'stack_puppet/mco/mco.conf',
  $mco_options_hash                  = { },

  $mysql_install                    = false,
  $mysql_config_template            = '',
  $mysql_options_hash                = { },

  $foreman_install                  = false,
  $foreman_config_template          = 'stack_puppet/foreman/foreman.conf',
  $foreman_options_hash              = { },

  $foremanproxy_install             = false,
  $foremanproxy_config_template     = 'stack_puppet/foremanproxy/foremanproxy.conf',
  $foremanproxy_options_hash         = { },

  $puppetdashboard_install          = false,
  $puppetdashboard_config_template  = 'stack_puppet/puppetdashboard/puppetdashboard.conf',
  $puppetdashboard_options_hash      = { },

  ) {

  # TODO: Create default templates
  # TODO: Provide defaults for options_hash
  # TODO: Complete with all classes and defines
  # TODO: Define the parmaters to expose and to use
  # TODO: Define the application modules to use

  # TODO: Test if this puppetdbquery thing works
  $puppetmaster_servers = query_nodes('Class[puppet::server]')
  $puppetmaster_servers_ip = query_nodes('Class[puppet::server]', ipaddress)


  $puppetdb_servers = query_nodes('Class[puppetdb]')
  $puppetdb_servers_ip = query_nodes('Class[puppetdb', ipaddress)

  # TODO: More robust real (and only) puppet related activemq servers recognition
  $activemq_servers = query_nodes('Class[activemq]')
  $activemq_servers_ip = query_nodes('Class[activemq', ipaddress)

  $foremanproxy_servers = query_nodes('Class[foremanproxy]')
  $foremanproxy_servers_ip = query_nodes('Class[foremanproxy]' ipaddress)


  # TODO: Review inclusion logic to allow proper removal of previously declared classes
  if $puppet_install {
    class { 'puppet':
      run_mode      => $puppet_run_mode,
      template      => $puppet_config_template,
    }
  }

  # TODO: Decide if and how to expose credentials params
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
