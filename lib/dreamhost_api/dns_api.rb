
class DreamhostAPI
  class DnsAPI
    def initialize(api)
      @api = api
    end

    def list_records
      return @api.request('cmd=dns-list_records&type=A&editable=1')
    end

    def remove_record(record)
      return @api.request('cmd=dns-remove_record&type=A&record=' +
                          record['record'] + '&value=' + record['value'])
    end

    def add_record(record)
      return @api.request('cmd=dns-add_record&type=A&record=' +
                          record['record'] + '&value=' + record['value'])
    end
  end
end
