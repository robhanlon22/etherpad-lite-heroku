#!/usr/bin/env ruby

require 'fileutils'
require 'json'

require_relative './settings'

File.open('APIKEY.txt', 'w') { |f| f.write(ENV['ETHERPAD_API_KEY']) }
File.open('settings.json', 'w') { |f| f.write(SETTINGS.to_json) }

FileUtils.mkdir_p('etherpad-lite/src/node_modules')

unless File.exists?('node_modules')
  abort('Failed to run npm install.') unless system('npm install')
end

Dir['node_modules/*'].each do |directory|
  FileUtils.ln_sf("#{Dir.pwd}/#{directory}", "#{Dir.pwd}/etherpad-lite/src/node_modules/#{File.basename(directory)}")
end

FileUtils.ln_sf("#{Dir.pwd}/etherpad-lite/src", "#{Dir.pwd}/node_modules/ep_etherpad-lite")

FileUtils.rm_rf('etherpad-lite/src/node_modules/ep_etherpad-lite')
FileUtils.rm_rf('etherpad-lite/src/src')

exec 'node node_modules/ep_etherpad-lite/node/server.js'
