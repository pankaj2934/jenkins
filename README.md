
MODULE TO BUILD JENKINS MASTER
==============================


-Author :: iad@staples.com

-Links  : [Project url](https://handlebar.staples.com:8443/projects/PUP/repos/jenkins/)

Overview
--------

Install jenkins package dependencies and pluginsfor Debian, Ubuntu, Fedora, and RedHat.

Installs some plugins by default.


Getting Started
----------------
    git clone https://handlebar.staples.com:8443/scm/pup/jenkins.git
    puppet apply -e "include jenkins::install"


What to Expect
--------------
After the puppet run is successful   **https://servername:8080**    should be live and show jenkins homepage


what is installed 
-----------------

Dependency installation

     $packages    = [ "java-1.6.0-openjdk", "npm", "ruby", "git", "python", "perl"],
     package{ $packages:  }
     package    {'sass':provider => 'gem',  require  => Package['ruby'],
     
Installation of jenkins package   ** Dependent on Internet access **


     yumrepo {'jenkins':
      descr    => 'Jenkins',
      baseurl  => 'http://pkg.jenkins-ci.org/redhat-stable/',
      gpgcheck => 1,
      gpgkey   => 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key',
        }
     
     package {'jenkins': ensure  => installed, require => [ Yumrepo['jenkins'],File['/var/lib/jenkins'] ], } }
     
Jenkin plugins installed by default
------------------------------------
-  ssh-slaves 

            jenkins::plugin{'ssh-slaves': name  => 'ssh-slaves',}

FileSystems Created 
-------------------

/var/opt/jenkins is created with user jenkins and group jenkins . ** lv_size should be ajusted **

    class jenkins::install
    (
            $install_dir = '/var/opt/jenkins',
            $lv_size     = '2G',     
            $user        = 'jenkins',
            $group       = 'jenkins',
            $ensure      = 'present',
            $packages    = [ "java-1.6.0-openjdk", "npm", "ruby", "git", "python", "perl"],
    )
    splslib::filesystem { $install_dir:
            install_dir => $install_dir,
            lv_size     => $lv_size,
            user        => $user,
            group       => $group,
            require     => User[ $user ],
    }

Users Created
-------------
jenkins user is created before anything is installed 

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
          
    
