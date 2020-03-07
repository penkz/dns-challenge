require 'rails_helper'

RSpec.describe(Hostname, type: :model) do
  describe 'validations' do
    it { should validate_presence_of(:hostname) }
  end
end
