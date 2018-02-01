Types::DoctorType = GraphQL::ObjectType.define do
  name "Doctor"

  backed_by_model :doctor do
    attr :id
    attr :home_address
    attr :license_front_media_id
    attr :graduate_institution
    # attr :id_card_front
    # attr :updated_at
    attr :good_at
    attr :write_uid
    attr :license_back_media_id
    attr :create_uid
    attr :user_id
    attr :hospital
    # attr :license_front
    attr :id_card_front_media_id
    # attr :date_of_birth
    attr :work_address
    attr :job_title
    attr :mobile_phone
    attr :id_card_back_media_id
    # attr :id_card_back
    # attr :write_date
    attr :aasm_state
    attr :remark
    attr :name
    attr :gender
    # attr :created_at
    # attr :create_date
    # attr :avatar
    # attr :license_back
    attr :age
    attr :id_card_num
  end
end
