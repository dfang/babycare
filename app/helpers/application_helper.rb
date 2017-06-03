# frozen_string_literal: true

module ApplicationHelper
  def underscore_body_class
    body_class = params[:controller].underscore.tr('/', '_')
    body_class += '_' + params[:action].underscore
    body_class
  end
end
