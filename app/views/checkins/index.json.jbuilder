json.array!(@checkins) do |checkin|
  json.extract! checkin, :id, :name, :mobile_phone, :birthdate, :gender, :email, :job, :employer, :nationality, :province_id, :city_id, :area_id, :address, :source, :remark
  json.url checkin_url(checkin, format: :json)
end
