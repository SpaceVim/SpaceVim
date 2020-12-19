# Syntax error at end of input (line number is not given)
class foo {
  file { 'bar':
    ensure => 'file',
    mode   => '0666'
  }

