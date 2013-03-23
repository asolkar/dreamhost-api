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
  class DnsAPI
    def initialize(api)
      @api = api
    end

    def list_records
      return @api.request({ :cmd => 'dns-list_records',
                            :type => 'A',
                            :editable =>'1'});
    end

    def remove_record(record)
      return @api.request({ :cmd => 'dns-remove_record',
                            :type => 'A',
                            :record => record['record'],
                            :value => record['value']})
    end

    def add_record(record)
      return @api.request({ :cmd => 'dns-add_record',
                            :type => 'A',
                            :record => record['record'],
                            :value => record['value']})
    end
  end
end
