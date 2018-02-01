Types::AuthenticationType = GraphQL::ObjectType.define do
  name "Authentication"
  backed_by_model :Authentication do
    attr :uid
  end
end
