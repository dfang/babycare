# frozen_string_literal: true

require 'wx_app'

class Admin::WxMenusController < Admin::BaseController
  defaults resource_class: WxMenu, collection_name: 'wx_menus', instance_name: 'wx_menu'

  def create
    create! do |success, failure|
      success.html { redirect_to admin_wx_menus_path }
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_wx_menus_path }
      failure.html { render :edit }
    end
  end

  def load_remote
    WxApp::WxButton.load_remote_menus
    redirect_to admin_wx_menus_path(@instance)
  end

  def sync
    response = WxApp::WxButton.create_remote_menus(WxApp::WxButton.build_menus)
    body = JSON.parse response.body

    if body['errcode'].zero?
      flash[:notice] = '同步成功'
    else
      flash[:alert] = "#{body['errcode']}, #{body['errmsg']}"
    end
    redirect_to admin_wx_menus_path
  end

  protected

  def wx_menu_params
    params.require(:wx_menu).permit!
  end

  def collection
    end_of_association_chain.page(params[:page])
  end
end
