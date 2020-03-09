class DnsRecordsController < ApplicationController
  def index
    render(json: { hey: 'Hello' })
    # DnsRecord.joins(:hostnames).where(hostnames: { hostname: ['dolor.com', 'ipsum.com'] }).group(:id).having('count(*) = 2')
  end

  def create
    @resource = DnsRecord.new(dns_record_params)

    if @resource.save
      render(:create, status: :created)
    else
      render(json: { errors: @resource.errors }, status: :unprocessable_entity)
    end
  end

  def dns_record_params
    params.require(:dns_records).permit(:ip, hostnames_attributes: [:hostname])
  end
end
