# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :reservation do
    reservation_remark { %w[咳嗽 发热 感冒 发高烧 拉肚子 水痘 幼儿急疹 过敏性皮炎 哮喘 鼻炎 支气管炎 肺炎].sample }
    chief_complains '我发烧了, 头好痛啊'
    aasm_state :to_prepay
    reservation_name 'aaa'
    p_phone '17671757383'
    user_id { User.order('RANDOM()').first.id }

    association :family_member, factory: :user
    association :user, factory: :user

    factory :pending_reservations do
      doctor_id nil
      aasm_state :pending
    end

    factory :reserved_reservations do
      user_id { User.all.select { |x| x.doctor.nil? }.sample.id }
      doctor_id { User.all.select { |x| x.doctor.present? }.sample.id }
      aasm_state :reserved
    end
  end
end
