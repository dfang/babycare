# json.content format_content(@message.content)
# json.(@message, :created_at, :updated_at)
#
# json.author do
#   json.name @message.creator.name.familiar
#   json.email_address @message.creator.email_address_with_name
#   json.url url_for(@message.creator, format: :json)
# end
#
#
# ReservationExamination(id: integer, examination_id: integer,
#   reservation_id: integer)
#
# ReservationExaminationImage(id: integer, create_uid: integer, create_date: datetime, write_uid: integer, write_date: datetime, media_id: string, data: string, reservation_examination_id: integer)

json.array! @reservation_examinations do |examin|
  json.reservation_id exmain.reservation_id
  json.examination_id exmain.examination_id


  json.array! @reservation_examination_images, :media
end

#
#
#
#
# [{"id"=>1,
#   "create_uid"=>nil,
#   "examination_id"=>1,
#   "reservation_id"=>1,
#   "reservation_examination_images"=>[]},
#  {"id"=>2,
#   "create_uid"=>nil,
#   "examination_id"=>2,
#   "reservation_id"=>1,
#   "reservation_examination_images"=>
#    [{"media_id"=>"CHCJ92XxUfMBqNFzij_nh8SRN54amCmZQakfLJR9W5K6DVb5VJhw9TBDFhfMMBOG"},
#     {"media_id"=>"v8c291o59QHvgr3ngBS6RbBSiBX7_sHmvhCf0ciH7InUqbIiFQ9Xn-fcVFzl8D6h"},
#     {"media_id"=>"3-cWGPb9dZXRZReGx9zZbM_0cK_9rwrpUrQzZDd0K44PACLjw-roiBNHSdGgtf7-"}]},
#  {"id"=>3,
#   "create_uid"=>nil,
#   "examination_id"=>3,
#   "reservation_id"=>1,
#   "reservation_examination_images"=>
#    [{"media_id"=>"ij8DbTFrOjGXceGpN3AlHw5InGyRLtxAAAkviPeKkLaeMgIStbenO75UiZO7JjjD"},
#     {"media_id"=>"tWDooEC96E2THSwb_aBTCurQH5OAFp1GWiOqeoJO2gKXpyDIpWlEIdFtJ_kwjWmJ"}]}]
