class GlobalImagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json, :js

  def create
    p request

    @image = GlobalImage.new
    @image.data = params[:file]
		p "image size is #{@image.data.size/1024} KB"

    @image.save!
    # p @image
    # @image
    respond_to do |format|
      format.js { }
      format.html
    end

  end
end
