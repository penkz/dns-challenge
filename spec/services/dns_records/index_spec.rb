require 'rails_helper'

RSpec.describe(DnsRecords::Index, type: :service) do
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

  describe '.run!' do
    context 'when includes and excludes params are omitted' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record.id, ip_address: dns_record.ip.to_s },
            { id: dns_record_2.id, ip_address: dns_record_2.ip.to_s },
            { id: dns_record_3.id, ip_address: dns_record_3.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'amet.com' },
            { count: 2, hostname: 'dolor.com' },
            { count: 2, hostname: 'ipsum.com' },
            { count: 2, hostname: 'lorem.com' },
            { count: 1, hostname: 'sit.com' },
          ],
          total_records: 3,
        }
      end

      it 'returns all dns_records' do
        expect(described_class.run!(page: 1)).to(match(expected_result))
      end
    end

    context 'when includes array is present with one value' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record_2.id, ip_address: dns_record_2.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'dolor.com' },
            { count: 1, hostname: 'ipsum.com' },
            { count: 1, hostname: 'lorem.com' },
          ],
          total_records: 1,
        }
      end

      it 'returns matching dns_records' do
        expect(described_class.run!(includes: ['amet.com'], page: 1)).to(match(expected_result))
      end
    end

    context 'when includes array is present with multiple values' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record.id, ip_address: dns_record.ip.to_s },
            { id: dns_record_2.id, ip_address: dns_record_2.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'amet.com' },
            { count: 2, hostname: 'lorem.com' },
          ],
          total_records: 2,
        }
      end

      it 'returns matching dns_records' do
        expect(described_class.run!(includes: ['dolor.com', 'ipsum.com'], page: 1)).to(match(expected_result))
      end
    end

    context 'when excludes array is present with one value' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record.id, ip_address: dns_record.ip.to_s },
            { id: dns_record_3.id, ip_address: dns_record_3.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'dolor.com' },
            { count: 1, hostname: 'ipsum.com' },
            { count: 1, hostname: 'lorem.com' },
            { count: 1, hostname: 'sit.com' },
          ],
          total_records: 2,
        }
      end

      it 'returns matching dns_records' do
        expect(described_class.run!(excludes: ['amet.com'], page: 1)).to(match(expected_result))
      end
    end

    context 'when excludes array is present with multiple values' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record.id, ip_address: dns_record.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'dolor.com' },
            { count: 1, hostname: 'ipsum.com' },
            { count: 1, hostname: 'lorem.com' },
          ],
          total_records: 1,
        }
      end

      it 'returns matching dns_records' do
        expect(described_class.run!(excludes: ['amet.com', 'sit.com'], page: 1)).to(match(expected_result))
      end
    end

    context 'when includes and excludes arrays are present' do
      let(:expected_result) do
        {
          records: [
            { id: dns_record.id, ip_address: dns_record.ip.to_s },
          ],
          related_hostnames: [
            { count: 1, hostname: 'lorem.com' },
          ],
          total_records: 1,
        }
      end

      it 'returns matching dns_records' do
        expect(described_class.run!(
          includes: ['dolor.com', 'ipsum.com'],
          excludes: ['amet.com'],
          page: 1
        )).to(match(expected_result))
      end
    end
  end
end
