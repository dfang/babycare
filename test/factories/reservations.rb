require 'ffaker'

FactoryGirl.define do
  factory :reservation do
    name { Faker::Name.name }
    mobile_phone 17_762_575_774
    child_gender { %w(儿子 女儿).sample }
    remark { %w(咳嗽 发热 感冒 发高烧 拉肚子 水痘 幼儿急疹 过敏性皮炎 哮喘 鼻炎 支气管炎 肺炎).sample }
		aasm_state :pending
		user_a { User.all.select { |x| x.doctor.nil? }.sample.id }

		factory :reserved_reservations do
			aasm_state :reserved
			user_b { User.all.select { |x| x.doctor.present? }.sample.id }
		end
  end
end
