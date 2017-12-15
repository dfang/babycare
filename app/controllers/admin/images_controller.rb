# frozen_string_literal: true

class Admin::ImagesController < ApplicationController
  # before_action :authenticate_user!

  respond_to :json, :js, :html

  def create
    @image = Image.create!(data: params[:image])
  end
end
