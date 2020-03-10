class ApplicationController < ActionController::API
  private

  def split_at_comma(str)
    str&.split(',')
  end
end
