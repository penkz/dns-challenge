class DnsRecordsController < ApplicationController
  def index
    @records = DnsRecords::Index.run(
      page: params[:page],
      includes: split_at_comma(params[:includes]),
      excludes: split_at_comma(params[:excludes])
    )

    if @records.success?
      render(@records.result)
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
end
