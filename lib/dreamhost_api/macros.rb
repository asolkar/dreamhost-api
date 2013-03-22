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
