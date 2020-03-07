class DnsRecord < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
end
