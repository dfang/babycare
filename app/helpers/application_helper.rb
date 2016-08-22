module ApplicationHelper
	def underscore_body_class
		body_class = params[:controller].underscore.gsub('/','_')
		body_class += '_' + params[:action].underscore
		body_class
	end
end
