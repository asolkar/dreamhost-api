# -----
#
# Copyright (c) 2013 Mahesh Asolkar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# -----
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

  def set_config(config)
    @config = config
  end

  def request(resource)
    url = @api_url + '?key=' + @apikey +
          '&unique_id=' + SecureRandom.uuid + '&format=yaml&' +
          resource

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
    response = http.get(uri.request_uri)

    yaml_data = YAML::load_stream(response.body)
    # puts YAML::dump(yaml_data)
    return yaml_data[0]
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
    Macros.new(self, @config)
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
