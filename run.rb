#!/usr/bin/env ruby

require 'fileutils'
require 'json'
require 'uri'

# Create settings hash add merge in the user-provided JSON.
mysql_uri = URI.parse(ENV['DATABASE_URL'])
settings = {
  dbType: 'mysql',
  dbSettings: {
    user: mysql_uri.user,
    host: mysql_uri.host,
    password: mysql_uri.password,
    database: mysql_uri.path.sub(%r{^/}, '')
  },
  defaultPadText: '',
  editOnly: true,
  requireSession: true,
  title: '',
}.merge(JSON.parse(ENV.fetch('ETHERPAD_SETTINGS', {}.to_json)))

# Write the user-provided API key.
File.open('APIKEY.txt', 'w') { |f| f.write(ENV['ETHERPAD_API_KEY']) }

# Write the settings hash out as JSON.
File.open('settings.json', 'w') { |f| f.write(settings.to_json) }

# Make a home for etherpad-lite's node modules.
FileUtils.mkdir_p('etherpad-lite/src/node_modules')

# Run npm install. Heroku will have run this already.
unless File.exists?('node_modules')
  abort('Failed to run npm install.') unless system('npm install')
end

# Install all user-specified plugins.
ENV.fetch('ETHERPAD_PLUGINS', '').split(',').each do |etherpad_plugin|
  unless system("npm install --production ep_#{etherpad_plugin}")
    abort("Failed to install plugin #{etherpad_plugin}.")
  end
end

# Symlink all plugins from the node_modules directory at the root into etherpad-lite's node_modules
# directory. This must be done because the server will not be able to find these modules at
# the root of the app, which is where Heroku puts them.
Dir['node_modules/*'].each do |directory|
  FileUtils.ln_sf(
    "#{Dir.pwd}/#{directory}",
    "#{Dir.pwd}/etherpad-lite/src/node_modules/#{File.basename(directory)}"
  )
end

# Link etherpad-lite into the root node_modules directory.
FileUtils.ln_sf("#{Dir.pwd}/etherpad-lite/src", "#{Dir.pwd}/node_modules/ep_etherpad-lite")

# Remove the circular reference if it exists. etherpad-lite will attempt to load itself infinitely
# if this is exists.
FileUtils.rm_rf('etherpad-lite/src/node_modules/ep_etherpad-lite')

# Remove this odd straggling symlink that kept showing up. Lazy.
FileUtils.rm_rf('etherpad-lite/src/src')

# Run the server.
exec('node node_modules/ep_etherpad-lite/node/server.js')
