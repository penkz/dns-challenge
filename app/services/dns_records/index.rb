module DnsRecords
  class Index < Mutations::Command
    required do
      string :page
    end

    optional do
      array :includes
      array :excludes
    end

    def execute
      {
        total_records: total_records,
        records: result.map { |record| { id: record.id, ip_address: record.ip.to_s } },
        related_hostnames: formatted_related_hostnames,
      }
    end

    private

    def result
      @result ||= if excluded_dns_records_ids.blank?
        matching_dns_records
      else
        matching_dns_records.where.not(id: excluded_dns_records_ids)
      end
    end

    def total_records
      result.to_a.size
    end

    def matching_dns_records
      return included_dns_records unless includes.blank?

      DnsRecord.all
    end

    def excluded_dns_records_ids
      @excluded_dns_records_ids ||= excluded_hostnames.pluck(:dns_record_id)
    end

    def all_specified_domains
      [includes, excludes].flatten.compact
    end

    def formatted_related_hostnames
      related_hostnames.map { |k, v| { hostname: k, count: v } }
    end

    def included_dns_records
      @included_dns_records ||= DnsRecord
        .joins(:hostnames)
        .where(hostnames: { hostname: includes })
        .group(:id)
        .having("count(*) = ?", includes.size)
    end

    def excluded_hostnames
      @excluded_dns_records ||= Hostname
        .joins(:dns_records)
        .where(hostname: excludes)
        .distinct
    end

    def related_hostnames
      Hostname
        .joins(:dns_records)
        .where(dns_records: { id: result.ids })
        .group(:hostname)
        .where.not(hostname: all_specified_domains).count
    end
  end
end
