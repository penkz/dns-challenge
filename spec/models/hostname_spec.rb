require 'rails_helper'

RSpec.describe(Hostname, type: :model) do
  describe 'validations' do
    it { should validate_presence_of(:hostname) }
  end

  describe 'associations' do
    it { should have_many(:dns_records).through(:dns_records_hostnames) }
  end
end
