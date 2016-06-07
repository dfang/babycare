class Admin::ImagesController < ApplicationController
  # before_filter :authenticate_user!

  respond_to :json, :js, :html

  def create
    @image = Image.new
    @image.data = params[:image]
    # @image.target_type = params[:page]
    # @image.user = current_user
    @image.save!
  end
end
