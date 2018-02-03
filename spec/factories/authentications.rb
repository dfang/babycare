# frozen_string_literal: true

FactoryGirl.define do
  factory :authentication do
    factory :authentication1 do
      provider :wechat
      uid 'ofUe6uGTMOaH2-CvIRl62ABoCJ_c'
      nickname 'Fang Duan'
      unionid 'oV5bUwuMUqVOX-WqpKxZGaoR_RVQ'
      # association :user, factory: :user1
    end

    factory :authentication2 do
      provider :wechat
      uid 'ofUe6uLcb7JoLWH-Tw0QOxfPreGc'
      nickname 'Prince'
      association :user, factory: :user2
    end
  end
end
