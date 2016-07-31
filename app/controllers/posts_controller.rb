class PostsController < InheritedResources::Base
  before_action :authenticate_user!

  def index
  end

  def show
  end
end
