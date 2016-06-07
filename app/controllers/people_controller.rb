class PeopleController < InheritedResources::Base

  private

    def person_params
      params.require(:person).permit(:name, :mobile_phone, :birthdate, :gender, :email, :job, :employer, :nationality, :province_id, :city_id, :area_id, :address, :source, :remark, :wechat, :qq)
    end
end

