class ProductsController < ApplicationController
  before_action -> { authenticate_user!(force: true) }

  def index
  end

  def show
  end
end
