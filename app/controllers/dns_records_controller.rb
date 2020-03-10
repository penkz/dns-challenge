class DnsRecordsController < ApplicationController
  def index
    excludes = split_at_comma(params[:excludes])
    includes = split_at_comma(params[:includes])

    @records = DnsRecords::Index.run(page: params[:page], includes: includes, excludes: excludes)

    if @records.success?
      render(json: @records.result)
    else
      render(json: @records.errors.message, status: :bad_request)
    end
  end

  def create
    @resource = DnsRecord.new(dns_record_params)

    if @resource.save
      render(:create, status: :created)
    else
      render(json: { errors: @resource.errors }, status: :unprocessable_entity)
    end
  end

  private

  def dns_record_params
    params.require(:dns_records).permit(:ip, hostnames_attributes: [:hostname])
  end

  def split_at_comma(str)
    str&.split(',')
  end
end
