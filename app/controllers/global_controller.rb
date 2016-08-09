class GlobalController < ApplicationController
  def status
  end

  def denied
    @warning = flash[:error]
  end
end
