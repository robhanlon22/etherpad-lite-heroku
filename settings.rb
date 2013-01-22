require 'uri'

mysql_uri = URI.parse(ENV['DATABASE_URL'])

SETTINGS = {
  title: 'Etherpad Lite',
  favicon: 'favicon.ico',
  ip: '0.0.0.0',
  port: ENV['PORT'],
  dbType: 'mysql',
  dbSettings: {
    user: mysql_uri.user,
    host: mysql_uri.host,
    password: mysql_uri.password,
    database: mysql_uri.path.sub(%r{^/}, '')
  },
  logconfig: {
    appenders: [ type: 'console' ]
  },
  defaultPadText:
    "Welcome to Etherpad Lite!\n\nThis pad text is synchronized as you type, so that everyone "\
    "viewing this page sees the same text. This allows you to collaborate seamlessly on "\
    "documents!\n\nGet involved with Etherpad at http:\/\/etherpad.org\n",
  requireSession: false,
  editOnly: false,
  minify: true,
  maxAge: 21600,
  abiword: nil,
  requireAuthentication: false,
  requireAuthorization: false,
  loglevel: 'INFO',
  socketTransportProtocols: ['xhr-polling', 'jsonp-polling', 'htmlfile']
}
