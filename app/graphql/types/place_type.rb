Types::PlaceType = GraphQL::ObjectType.define do
  name "Place"

  field :title, types.String
  field :description, types.String
end
