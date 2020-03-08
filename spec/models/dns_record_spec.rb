require 'rails_helper'

RSpec.describe(DnsRecord, type: :model) do
  describe 'validations' do
    it { should validate_presence_of(:ip) }
    it { should validate_uniqueness_of(:ip) }
  end

  describe 'associations' do
    it { should have_many(:hostnames).through(:dns_records_hostnames) }
    it { should accept_nested_attributes_for(:hostnames) }
  end
end
