require 'uri'

mysql_uri = URI.parse(ENV['ETHERPAD_DATABASE_URL'])

SETTINGS = {
  favicon: 'favicon.ico',
  ip: '0.0.0.0',
  dbType: 'mysql',
  dbSettings: {
    user: mysql_uri.user,
    host: mysql_uri.host,
    password: mysql_uri.password,
    database: mysql_uri.path.sub(%r{^/}, '')
  },
  requireSession: true,
  editOnly: true,
  minify: true,
  maxAge: 21600,
  requireAuthentication: false,
  requireAuthorization: false,
  loglevel: 'INFO',
  socketTransportProtocols: ['xhr-polling', 'jsonp-polling', 'htmlfile']
}
