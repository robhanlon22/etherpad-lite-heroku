require 'uri'

mysql_uri = URI.parse(ENV['ETHERPAD_DATABASE_URL'])

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
  logconfig: {},
  requireSession: true,
  title: '',
}
