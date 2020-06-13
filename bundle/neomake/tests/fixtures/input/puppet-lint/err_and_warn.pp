class foo {
  file { "bar":
    ensure => 'file',
    mode => '0666'
  }
}

