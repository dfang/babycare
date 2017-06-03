# frozen_string_literal: true

FactoryGirl.define do
  factory :transaction do
    reservation_id 'MyString'
    amount 1.5
    source 'MyString'
    withdraw_target 'MyString'
    operation 'MyString'
  end
end
