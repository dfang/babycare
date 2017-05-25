class Admin::BaseController < InheritedResources::Base
  layout 'admin'
  # before_action :authenticate_admin_user!

  def create
    create! { collection_path }
  end

  def update
    # avoid bugs in admin/events
    if params.key?(:event) && !params[:controller].include?('event')
      resource.send("#{params[:event]}!")
      redirect_to :back and return
    else
      update! { collection_path }
    end
  end

  def destroy
    destroy! { collection_path }
  end

  # def collection
  #   binding.pry
  #   super.page(params[:page])
  # end

  # def end_of_association_chain
  #   super.order('created_at DESC')
  # end
end
