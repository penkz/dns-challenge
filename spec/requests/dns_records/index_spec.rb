require 'rails_helper'

RSpec.describe('List DNS Records', type: :request) do
  let(:dns_record) { FactoryBot.create(:dns_record, ip: '1.1.1.1') }
  let(:dns_record_2) { FactoryBot.create(:dns_record, ip: '2.2.2.2') }
  let(:dns_record_3) { FactoryBot.create(:dns_record, ip: '3.3.3.3') }

  before do
    dns_record.hostnames << [
      FactoryBot.build(:hostname, hostname: 'ipsum.com'),
      FactoryBot.build(:hostname, hostname: 'lorem.com'),
      FactoryBot.build(:hostname, hostname: 'dolor.com'),
    ]

    dns_record_2.hostnames << [
      FactoryBot.build(:hostname, hostname: 'dolor.com'),
      FactoryBot.build(:hostname, hostname: 'amet.com'),
      FactoryBot.build(:hostname, hostname: 'ipsum.com'),
      FactoryBot.build(:hostname, hostname: 'lorem.com'),
    ]

    dns_record_3.hostnames << [
      FactoryBot.build(:hostname, hostname: 'sit.com'),
    ]
  end

  describe 'get /dns_records' do
    context 'when the inputs are valid' do
      it 'returns 200 ok' do
        get dns_records_path, params: { page: 1 }
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'when page is missing' do
      before(:each) { get dns_records_path }
      it 'returns an 400 bad request' do
        expect(response).to(have_http_status(:bad_request))
      end

      it 'returns an error message' do
        expect(response.body).to(match(/Page can't be nil/))
      end
    end

    before { allow(DnsRecords::Index).to(receive(:run).and_call_original) }

    context 'when no domains have been specified ' do
      let(:expected_result) do
        {
          "records" => match_array([
            { "id" => dns_record.id, "ip_address" => "1.1.1.1" },
            { "id" => dns_record_2.id, "ip_address" => "2.2.2.2" },
            { "id" => dns_record_3.id, "ip_address" => "3.3.3.3" },
          ]),
          "related_hostnames" => match_array([
            { "count" => 1, "hostname" => "amet.com" },
            { "count" => 2, "hostname" => "dolor.com" },
            { "count" => 2, "hostname" => "ipsum.com" },
            { "count" => 2, "hostname" => "lorem.com" },
            { "count" => 1, "hostname" => "sit.com" },
          ]),
          "total_records" => 3,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1 }
        expect(DnsRecords::Index).to(have_received(:run).with({ page: '1', includes: nil, excludes: nil }))
      end

      it 'returns all dns records' do
        get dns_records_path, params: { page: 1 }
        expect(json_response).to(match(expected_result))
      end
    end

    context 'when a dns was specified in includes' do
      let(:includes) { 'dolor.com' }
      let(:expected_result) do
        {
          "records" => match_array([
            { "id" => dns_record.id, "ip_address" => "1.1.1.1" },
            { "id" => dns_record_2.id, "ip_address" => "2.2.2.2" },
          ]),
          "related_hostnames" => match_array([
            { "count" => 2, "hostname" => "ipsum.com" },
            { "count" => 2, "hostname" => "lorem.com" },
            { "count" => 1, "hostname" => "amet.com" },
          ]),
          "total_records" => 2,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(DnsRecords::Index).to(have_received(:run).with({ page: '1', includes: [includes], excludes: nil }))
      end

      it 'returns matching records' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(json_response).to(match(expected_result))
      end
    end

    context 'when multiple dns were specified in includes' do
      let(:includes) { 'dolor.com,amet.com,ipsum.com' }
      let(:expected_result) do
        {
          "records" => match_array([
            { "id" => dns_record_2.id, "ip_address" => "2.2.2.2" },
          ]),
          "related_hostnames" => match_array([
            { "count" => 1, "hostname" => "lorem.com" },
          ]),
          "total_records" => 1,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(DnsRecords::Index).to(have_received(:run).with({ page: '1', includes: includes.split(','), excludes: nil }))
      end

      it 'returns matching records' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(json_response).to(match(expected_result))
      end
    end

    context 'when a dns was specified in excludes' do
      let(:excludes) { 'sit.com' }
      let(:expected_result) do
        {
          "records" => match_array([
            { "id" => dns_record.id, "ip_address" => "1.1.1.1" },
            { "id" => dns_record_2.id, "ip_address" => "2.2.2.2" },
          ]),
          "related_hostnames" => match_array([
            { "count" => 2, "hostname" => "ipsum.com" },
            { "count" => 2, "hostname" => "lorem.com" },
            { "count" => 2, "hostname" => "dolor.com" },
            { "count" => 1, "hostname" => "amet.com" },
          ]),
          "total_records" => 2,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1, excludes: excludes }
        expect(DnsRecords::Index).to(have_received(:run).with({ page: '1', includes: nil, excludes: [excludes] }))
      end

      it 'returns matching records' do
        get dns_records_path, params: { page: 1, excludes: excludes }
        expect(json_response).to(match(expected_result))
      end
    end

    context 'when a dns was specified in both includes and excludes' do
      let(:includes) { 'dolor.com,ipsum.com' }
      let(:excludes) { 'amet.com' }
      let(:expected_result) do
        {
          "records" => match_array([
            { "id" => dns_record.id, "ip_address" => "1.1.1.1" },
          ]),
          "related_hostnames" => match_array([
            { "count" => 1, "hostname" => "lorem.com" },
          ]),
          "total_records" => 1,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1, includes: includes, excludes: excludes }
        expect(DnsRecords::Index).to(have_received(:run).with(
          { page: '1', includes: includes.split(','), excludes: [excludes] }
        ))
      end

      it 'returns matching records' do
        get dns_records_path, params: { page: 1, includes: includes, excludes: excludes }
        expect(json_response).to(match(expected_result))
      end
    end

    context 'when no dns record matches' do
      let(:includes) { 'nonexistentdomain.com' }
      let(:expected_result) do
        {
          "records" => match_array([]),
          "related_hostnames" => match_array([]),
          "total_records" => 0,
        }
      end

      it 'calls DnsRecords::Index with the correct params' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(DnsRecords::Index).to(have_received(:run).with({ page: '1', includes: [includes], excludes: nil }))
      end

      it 'returns all dns records' do
        get dns_records_path, params: { page: 1, includes: includes }
        expect(json_response).to(match(expected_result))
      end
    end
  end
end
