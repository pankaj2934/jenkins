#
class jenkins::install
(
    $install_dir = '/var/opt/jenkins',
    $lv_size     = '2G',
    $user        = 'jenkins',
    $group       = 'jenkins',
    $ensure      = 'present',
    $packages    = [ 'java-1.6.0-openjdk','npm','git','ruby','python',"perl'],

)

{


######################################
#
#  setup jenkins user
#
#####################################

    user { 'jenkins':
        ensure           => "$ensure",
        uid              => 2436,
        gid              => 2436,
        comment          => 'Jenkins Continuous Build server',
        home             => '/var/lib/jenkins',
        shell            => '/bin/false',
        password         => '!!',
        password_max_age => '-1',
        password_min_age => '-1',


  }
        


#########################################
#
#  setup filesystem for jenkins install
#
#########################################

    splslib::filesystem { $install_dir:
    install_dir => $install_dir,
    lv_size     => $lv_size,
    user        => $user,
    group       => $group,
    require     => User[ $user ],
    }


#########################################
#
#  setup directory/home for jenkins install
#
#########################################

  file {'/var/lib/jenkins':
    ensure  => link,
    target  => $install_dir,
    require => Splslib::Filesystem[$install_dir],
  }


#########################################
#
#  install required packages for jenkins install
#
#########################################

  package{ "$packages":
    ensure     => "$ensure",
  }

  package{'sass':
    ensure   => "$ensure",
    provider => 'gem',
    require  => Package['ruby'],
  }



#########################################
#
#  install  jenkins from external repo 
#
#########################################


    yumrepo {'jenkins':
      descr    => 'Jenkins',
      baseurl  => 'http://pkg.jenkins-ci.org/redhat-stable/',
      gpgcheck => 1,
      gpgkey   => 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key',
    }

    package {'jenkins':
      ensure  => installed,
      require => [ Yumrepo['jenkins'],File['/var/lib/jenkins'] ],
  }

    service {'jenkins':
      ensure  => running,
      enable  => true,
      require => Package['jenkins'],
  }


#########################################
#
#  install  jenkins plugins 
#
#########################################
  
    file {'/var/lib/jenkins/plugins':
      ensure          => directory,
      owner           => 'jenkins',
      group           => 'jenkins',
      require         => Package['jenkins']
  }

  jenkins::plugin{'ssh-slaves':
    name  => 'ssh-slaves',
    }
    









}
