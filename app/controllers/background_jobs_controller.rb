class BackgroundJobsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json, :js

  def call
    puts params

    IM.call(params["caller"], params["callee"])  
  end

end
