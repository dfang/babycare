json.array!(@admin_people) do |admin_person|
  json.extract! admin_person, :id
  json.url admin_person_url(admin_person, format: :json)
end
