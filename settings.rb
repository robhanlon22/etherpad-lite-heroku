require 'uri'

mysql_uri = URI.parse(ENV['ETHERPAD_DATABASE_URL'])

settings = JSON.parse(ENV.fetch('ETHERPAD_SETTINGS', {}.to_json))

SETTINGS = {
  dbType: 'mysql',
  dbSettings: {
    user: mysql_uri.user,
    host: mysql_uri.host,
    password: mysql_uri.password,
    database: mysql_uri.path.sub(%r{^/}, '')
  },
  defaultPadText: '',
  editOnly: true,
  ip: '0.0.0.0',
  requireSession: true,
  title: '',
}.merge(settings)
