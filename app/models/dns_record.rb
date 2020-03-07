class DnsRecord < ApplicationRecord
  has_many :dns_records_hostnames
  has_many :hostnames, through: :dns_records_hostnames
  validates :ip, presence: true, uniqueness: true
end
