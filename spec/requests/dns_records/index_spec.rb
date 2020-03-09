require 'rails_helper'

RSpec.describe('List DNS Records', type: :request) do
  describe 'get /dns_records' do
    it 'returns 200 ok' do
      get dns_records_path
      expect(response).to(have_http_status(:ok))
    end
  end
end
