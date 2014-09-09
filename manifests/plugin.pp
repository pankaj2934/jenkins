#

define jenkins::plugin
(

  $name     ,
  $plugin     = "${name}.hpi",
  $version    = 'latest',
  $plugin_dir = '/var/lib/jenkins/plugins',
  
)

{
  if ($version == 'latest' ){
    $url="http://updates.jenkins-ci.org/latest/${plugin}"
  }
   else {
    $url="http://updates.jenkins-ci.org/download/plugins/${name}/${version}/${plugin}"
  }
  
    exec { "download-${name}" :
      command       => "wget --no-check-certificate ${url}",
      unless        => "test -d ${plugin_dir}/${name}",
      cwd           => $plugin_dir,
      path          => ['/usr/bin', '/usr/sbin', '/bin'],
      logoutput     => true,
      notify        => Service['jenkins'],
      }
  

}

