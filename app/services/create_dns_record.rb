class CreateDnsRecord < Mutations::Command
  required do
    string :ip
    array :hostnames_attributes
  end

  def execute
    dns_record.save
  end

  private

  def dns_record
    @dns_record ||= DnsRecord.new(inputs)
  end
end
