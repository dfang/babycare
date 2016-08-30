class Admin::PostsController < Admin::BaseController

  private

    def post_params
      params.require(:post).permit()
    end
end
