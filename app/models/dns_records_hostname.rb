class DnsRecordsHostname < ApplicationRecord
  belongs_to :dns_record
  belongs_to :hostname
end
