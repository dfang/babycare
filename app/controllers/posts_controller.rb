class PostsController < InheritedResources::Base
  before_action ->{ authenticate_user!( force: true ) }


  def index
    if current_user.doctor.present? && current_user.doctor.verified?
      @posts = Post.published.tagged_with("doctor")
    else
      @posts = Post.published.all
    end
  end

  def show
  end
end
