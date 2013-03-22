
class DreamhostAPI
  class DnsAPI
    def initialize(api)
      @api = api
    end

    def list_records
      response = @api.request('cmd=dns-list_records&type=A&editable=1')
      return response
      # FIXME: Return an array of DnsRecord type objects
    end

    def remove_record(record)
      puts "  Removing #{record['record']} : #{record['value']}"

      response = @api.request('cmd=dns-remove_record&type=A&record=' +
                              record['record'] + '&value=' + record['value'])

      if response == "record_removed"
        puts "    Info! #{record['record']} : #{record['value']} removed"
      else
        puts "    ERROR! #{record['record']} : #{record['value']} not removed properly"
      end
    end

    def add_record(record)
      puts "  Adding #{record['record']} -> #{@ip}"

      response = https_request('cmd=dns-add_record&type=A&record=' +
                               record['record'] + '&value=' + record['value'])

      if response == "record_added"
        puts "    Info! #{record['record']} : #{@ip} added"
      else
        puts "    ERROR! #{record['record']} : #{@ip} not added properly"
      end
    end
  end
end
