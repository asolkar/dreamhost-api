#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/lib'

require 'yaml'
require 'dreamhost_api'

config = YAML::load_file('config.yml')

dh = DreamhostAPI.new(config['api_key'])
dh.macros.update_records(config['records'])

