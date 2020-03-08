require 'rails_helper'

RSpec.describe('Create DNS Records', type: :request) do
  describe 'post /dns-records' do
    let(:valid_attributes) do
      {
        dns_records: {
          ip: '1.1.1.1',
          hostnames_attributes: [
            { hostname: 'example.com' },
            { hostname: 'somewhere.com' },
          ],
        },
      }
    end

    let(:invalid_attributes) do
      {
        dns_records: {
          ip: '',
          hostnames_attributes: [
            { hostname: 'example.com' },
            { hostname: 'somewhere.com' },
          ],
        },
      }
    end

    let(:success_response) do
      { "id" => instance_of(String) }
    end

    let(:invalid_response) do
      { 'errors' => instance_of(Hash) }
    end

    let(:json_response) { JSON.parse(response.body) }

    context 'with valid attributes' do
      it 'returns 201 created' do
        post dns_records_path, params: valid_attributes
        expect(response).to(have_http_status(:created))
      end

      it 'creates a new dns record' do
        post dns_records_path, params: valid_attributes
        expect(DnsRecord.count).to(eq(1))
      end

      it 'creates associated dns hostnames' do
        post dns_records_path, params: valid_attributes
        expect(DnsRecord.last.hostnames.count).to(eq(2))
      end

      it 'returns the correct response format' do
        post dns_records_path, params: valid_attributes
        expect(json_response).to(match(success_response))
      end
    end

    context 'with invalid attributes' do
      it 'returns 201 created' do
        post dns_records_path, params: invalid_attributes
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it 'returns the errors hash' do
        post dns_records_path, params: invalid_attributes
        expect(json_response).to(match(invalid_response))
      end
    end
  end
end
