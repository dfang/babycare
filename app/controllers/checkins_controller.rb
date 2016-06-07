class CheckinsController < InheritedResources::Base

  private

    def checkin_params
      params.require(:checkin).permit(:name, :mobile_phone, :birthdate, :gender, :email, :job, :employer, :nationality, :province_id, :city_id, :area_id, :address, :source, :remark)
    end
end

