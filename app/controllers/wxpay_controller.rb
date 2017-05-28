class WxpayController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? || request.format.xml? }

end
