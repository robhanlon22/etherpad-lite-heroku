#!/usr/bin/env ruby

require 'uri'
require 'erb'
require 'fileutils'

api_key = ENV['ETHERPAD_KEY']
port = ENV['PORT']

mysql_uri = URI.parse(ENV['DATABASE_URL'])

mysql_user = mysql_uri.user
mysql_host = mysql_uri.host
mysql_password = mysql_uri.password
mysql_database = mysql_uri.path.sub(%r{^/}, '')

apikey_txt = ERB.new(File.read('APIKEY.txt.erb')).result
settings_json = ERB.new(File.read('settings.json.erb')).result

File.open('APIKEY.txt', 'w') do |f|
  f.write(apikey_txt)
end

File.open('settings.json', 'w') do |f|
  f.write(settings_json)
end

FileUtils.mkdir_p('etherpad-lite/src/node_modules')

Dir['node_modules/*'].each do |directory|
  FileUtils.ln_sf("#{Dir.pwd}/#{directory}", "#{Dir.pwd}/etherpad-lite/src/node_modules/#{File.basename(directory)}")
end

FileUtils.rm_rf('etherpad-lite/src/node_modules/ep_etherpad-lite')
FileUtils.ln_sf("#{Dir.pwd}/etherpad-lite/src", "#{Dir.pwd}/node_modules/ep_etherpad-lite")

exec 'node node_modules/ep_etherpad-lite/node/server.js'
