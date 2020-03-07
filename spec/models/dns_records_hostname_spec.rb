require 'rails_helper'

RSpec.describe DnsRecordsHostname, type: :model do
  describe 'associations' do
    it { should belong_to(:dns_record) }
    it { should belong_to(:hostname) }
  end
end
