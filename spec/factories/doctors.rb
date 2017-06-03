# frozen_string_literal: true

FactoryGirl.define do
  factory :doctor do
    name 'Fang Duan'
    gender 'male'
    verified true
    mobile_phone '17762575774'

    # association :user, factory: :user2, strategy: :create
    # association :user, factory: :user2
    # user2
    user { User.last }

    factory :verified_doctor do
    end

    factory :unverified_doctor do
    end
  end
end
