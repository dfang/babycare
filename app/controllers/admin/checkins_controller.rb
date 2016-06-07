class Admin::CheckinsController < Admin::BaseController 

  private

    def checkin_params
      params.require(:checkin).permit()
    end
end

