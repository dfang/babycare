# frozen_string_literal: true

FactoryGirl.define do
  factory :bank_account do
    user nil
    account_name "MyString"
    account_number 1
    bank_branch_name "MyString"
  end
end
