# frozen_string_literal: true

class PostsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }

  def index
    @posts = if current_user.doctor.present? && current_user.doctor.verified?
               Post.published.tagged_with('doctor')
             else
               Post.published.all
             end
  end

  def show; end
end
