# frozen_string_literal: true

FactoryGirl.define do
  factory :hospital do
    name 'MyString'
    address 'MyString'
    phone 'MyString'
    nature 'MyString'
    type ''
    quality 'MyString'
    city nil
  end
end
