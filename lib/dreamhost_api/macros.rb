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
class DreamhostAPI

  class Macros
    def initialize(api, config)
      @api = api
      @config = config
      @ip = DreamhostAPI::get_my_ip
    end

    def update_records()
      return_value = 'records_updated'

      @new_ip = @ip
      if @config['update_records']['new_ip']
        @new_ip = @config['update_records']['new_ip']
      end

      response = @api.dns.list_records

      if response['result'] == 'success'
        @records = response['data']
        @records.each { |record|
          if @config['update_records']['records'].include?(record['record'])
            if record['editable'] == 1
              if record['value'] != @new_ip
                puts "#{record['record']} : #{record['value']} already is #{@new_ip}"
              else
                puts "Changing #{record['record']} : #{record['value']} -> #{@new_ip}"
                status = update_record(record)
                if status != 'record_updated'
                  puts "  ERROR! Failed to update record - #{status}"
                  return_value = 'one_or_more_record_update_failed'
                end
              end
            end
          end
        }
      else
        puts "Error! Could not fetch records - #{response['result']}"
        return_value = 'failed_to_fetch_records'
      end
      return return_value
    end

    def update_record(record)
      return_value = 'record_updated'

      response = @api.dns.remove_record(record)
      if response['result'] == "success"
        puts "    Info! #{record['record']} : #{record['value']} removed - #{response['data']}"
      else
        puts "    ERROR! #{record['record']} : #{record['value']} not removed properly - #{response['result']} - #{response['data']}"
        return 'record_update_failed_at_remove'
      end

      response = @api.dns.add_record(record)
      if response['result'] == "success"
        puts "    Info! #{record['record']} : #{@new_ip} added - #{response['data']}"
      else
        puts "    ERROR! #{record['record']} : #{@new_ip} not added properly - #{response['result']} - #{response['data']}"
        return 'record_update_failed_at_add'
      end

      return return_value
    end
  end
end
