class DnsRecordsController < ApplicationController
  def index; end

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
