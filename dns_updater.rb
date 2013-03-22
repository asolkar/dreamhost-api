#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/lib'

require 'yaml'
require 'dreamhost_api'

config = YAML::load_file('config.yml')

dh = DreamhostAPI.new(config['api_key'])
dh.set_config(config)

if config['update_records']
  status = dh.macros.update_records()
  if status != 'records_updated'
    puts "ERROR! Updating records failed - #{status}"
  end
end
