class tomcat::params {

  case $::osfamily {
    default: { fail("unsupported OS: ${::osfamily}") }
    'RedHat': {
      $admin_package   = [ 'tomcat7-admin-webapps', 'tomcat7-webapps' ]
      $autodeploy_dir  = '/var/lib/tomcat7/webapps'
      $docs_package    = 'tomcat7-docs-webapp'
      $group           = 'tomcat'
      $service         = 'tomcat7'
      $staging_dir     = '/var/lib/tomcat7/staging'
      $tomcat_package  = 'tomcat7'
      $user            = 'tomcat'
      $user_homedir    = '/usr/share/tomcat7'
    }
    'Debian': {
      $admin_package   = 'tomcat7-admin'
      $autodeploy_dir  = '/var/lib/tomcat7/webapps'
      $docs_package    = 'tomcat7-docs'
      $group           = 'tomcat7'
      $service         = 'tomcat7'
      $staging_dir     = '/var/lib/tomcat7/staging'
      $tomcat_package  = 'tomcat7'
      $user            = 'tomcat7'
      $user_homedir    = '/usr/share/tomcat7'
    }
    'Suse': {
      $admin_package   = [ 'tomcat7-admin-webapps', 'tomcat7-webapps' ]
      $autodeploy_dir  = '/usr/share/tomcat7/webapps'
      $docs_package    = 'tomcat7-docs-webapp'
      $group           = 'tomcat'
      $service         = 'tomcat7'
      $staging_dir     = '/usr/share/tomcat7/staging'
      $tomcat_package  = 'tomcat7'
      $user            = 'tomcat'
      $user_homedir    = '/usr/share/tomcat7'
    }
  }

}
