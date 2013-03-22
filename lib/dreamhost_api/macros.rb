class DreamhostAPI
  class Macros
    def initialize(api)
      @api = api
      @ip = DreamhostAPI::get_my_ip
    end

    def update_records(records)
      @records = @api.dns.list_records

      @records.each { |record|
        if records.include?(record['record'])
          if record['editable'] == 1
            if record['value'] == @ip
              puts "#{record['record']} : #{record['value']} already is #{@ip}"
            else
              puts "Changing #{record['record']} : #{record['value']} -> #{@ip}"
              # update_record(record)
            end
          end
        end
      }
    end

    def update_record(record)
      @api.remove_record(record)
      @api.add_record(record)
    end
  end
end
