require 'net/http'
require 'securerandom'
require 'yaml'

require 'dreamhost_api/dns_api'
require 'dreamhost_api/macros'

class DreamhostAPI
  def initialize(apikey)
    @api_url = 'https://api.dreamhost.com/';
    @apikey = apikey
  end

  def request(resource)
    uuid = SecureRandom.uuid

    url = @api_url + '?key=' + @apikey +
          '&unique_id=' + uuid + '&format=yaml&' +
          resource

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
    response = http.get(uri.request_uri)

    yaml_data = YAML::load_stream(response.body)
    return yaml_data[0]['data']
  end

  #
  # API Components
  #
  def dns
    DnsAPI.new(self)
  end

  #
  # Macros
  #
  def macros
    Macros.new(self)
  end
  #
  # Helpers
  #
  def self.get_my_ip
    uri = URI.parse('http://checkip.dyndns.org/')
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri.request_uri)
    parts = response.body.match(/(\d+\.\d+\.\d+\.\d+)/)
    return parts[1]
  end
end
