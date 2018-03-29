# frozen_string_literal: true

UserType = GraphQL::ObjectType.define do
  name "User"
  backed_by_model :user do
    attr :id
    attr :gender
    attr :email
  end
end
