require 'ffaker'

FactoryGirl.define do
  factory :reservation do
    name { Faker::Name.name }
    age {(1..10).to_a.sample }
    gender { %w(male female).sample }
    reservation_remark { %w(咳嗽 发热 感冒 发高烧 拉肚子 水痘 幼儿急疹 过敏性皮炎 哮喘 鼻炎 支气管炎 肺炎).sample }
    mobile_phone 15618903080
    reservation_phone 15618903080
    chief_complains "我发烧了, 头好痛啊"
		aasm_state :pending

    user_a { User.all.select { |x| x.doctor.nil? }.sample.id }

		factory :reserved_reservations do
			aasm_state :reserved
			user_b { User.all.select { |x| x.doctor.present? }.sample.id }
		end
  end
end
