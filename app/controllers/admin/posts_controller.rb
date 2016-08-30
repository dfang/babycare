class Admin::PostsController < Admin::BaseController

	def publish
    if params.key?(:id)
      resource.publish!
    end
    redirect_to admin_posts_path and return
  end

  private

    def post_params
      params.require(:post).permit!
    end
end
