ActiveRecordTimestamp = GraphQL::InterfaceType.define do
  name 'ActiveRecordTimestamp'
  field :createdAt, types.String, property: :created_at
  field :updatedAt, types.String, property: :updated_at
end
