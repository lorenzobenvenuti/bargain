class ApplicationController < ActionController::API
  include ExceptionHandler

  def params_to_associations(param, associations)
    return if param.nil?
    associations.clear
    param.each do |p|
      associations << yield(p)
    end
  end
end
