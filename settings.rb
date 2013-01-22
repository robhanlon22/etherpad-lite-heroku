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
  favicon: 'favicon.ico',
  ip: '0.0.0.0',
  logconfig: {},
  loglevel: 'INFO',
  maxAge: 21600,
  minify: true,
  requireAuthentication: false,
  requireAuthorization: false,
  requireSession: true,
  socketTransportProtocols: ['xhr-polling', 'jsonp-polling', 'htmlfile'],
  title: '',
}
