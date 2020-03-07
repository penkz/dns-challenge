class Hostname < ApplicationRecord
  validates :hostname, presence: true
end
