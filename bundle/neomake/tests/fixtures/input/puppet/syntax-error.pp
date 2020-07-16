# Syntax error at line 3
class foo
  file { 'bar':
    ensure => 'file',
    mode   => '0666'
  }
}

