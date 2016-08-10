class PostsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) } 


  def index
  end

  def show
  end
end
