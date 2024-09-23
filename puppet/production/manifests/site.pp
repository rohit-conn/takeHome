node default {
  case $facts['aws_role'] {
    'nginx': {
      include roles::nginx
    }
    'app': {
      include roles::app
    }
    default: {
      notify { 'Unknown role!': }
    }
  }
}

