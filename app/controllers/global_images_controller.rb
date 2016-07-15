class GlobalImagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :html, :json, :js

  def create
    # binding.pry
    @image = GlobalImage.new
    @image.data = params[:file]

    @image.save!
    # p @image
    # @image
    respond_to do |format|
      format.js { }
      format.html 
    end

  end
end
