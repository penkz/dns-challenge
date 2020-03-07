class Hostname < ApplicationRecord
  has_many :dns_records_hostnames
  has_many :dns_records, through: :dns_records_hostnames
  validates :hostname, presence: true
end
