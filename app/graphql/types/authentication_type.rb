# frozen_string_literal: true

AuthenticationType = GraphQL::ObjectType.define do
  name "Authentication"
  backed_by_model :Authentication do
    attr :uid
    attr :unionid
  end
end
