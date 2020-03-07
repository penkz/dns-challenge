require 'rails_helper'

RSpec.describe(DnsRecord, type: :model) do
  describe 'validations' do
    it { should validate_presence_of(:ip) }
    it { should validate_uniqueness_of(:ip) }
  end
end
