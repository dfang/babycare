# frozen_string_literal: true

# include FactoryGirl::Syntax::Methods

FactoryGirl.define do
  factory :user do
    factory :user1 do
      email 'df1228@gmail.com'
      password 'fake_password_for_factory_girl_to_work'
      name 'Fang Duan'
      gender 'male'
      avatar 'http://wx.qlogo.cn/mmopen/aXUpZVUYfjy1bkF6Zf9UrKSavhOkqDdUh6Tl2nm6q4084McNgZ4PrlkB9MRIVtpBVnicCkz30NzgZZo8EcGKUrQ/0'
      mobile_phone '15618903080'
    end

    factory :user2 do
      email 'wx_user_b6f77bab7d08ff2d5cf22b35d11a91f0@wx_email.com'
      name 'Prince'
      password 'fake_password_for_factory_girl_to_work'
      gender 'male'
      avatar 'http://wx.qlogo.cn/mmopen/wPnFnHcH8f8rREicMnuAO1BicFHiaMH0RamnIMt2icy9VgJwWP4H2Bah29Wv6R3E8VPBEep5v8t9Z78NzA0SKfkkJTnribBXC5icmia/0'
      mobile_phone '17762575774'
    end

    factory :patient_user do
    end
  end
end
