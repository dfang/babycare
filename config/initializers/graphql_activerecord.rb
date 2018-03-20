Types::DateTimeType = GraphQL::ScalarType.define do
  name 'DateTime'

  coerce_input ->(value, _ctx) { Time.zone.parse(value) }
  coerce_result ->(value, _ctx) { value.utc.iso8601 }
end
GraphQL::Models::DatabaseTypes.register(:datetime, Types::DateTimeType)

# # The gem assumes that if your model is called `MyModel`, the corresponding type is `MyModelType`.
GraphQL::Models.model_to_graphql_type = -> (model_class) { "#{model_class.name}Type".safe_constantize }

# # This proc takes a Relay global ID, and returns the Active Record model.
# GraphQL::Models.model_from_id = -> (id, context) {
#     model_type, model_id = NodeHelpers.decode_id(id)
#     model_type.find(model_id)
# }

# This proc essentially reverses that process:
# GraphQL::Models.id_for_model = -> (model_type_name, model_id) {
#     NodeHelpers.encode_id(model_type_name, model_id)
# }

# # This proc is used when you're authorizing changes to a model inside of a mutator:
# GraphQL::Models.authorize = -> (context, action, model) {
#   # Action will be either :create, :update, or :destroy
#   # Raise an exception if the action should not proceed
#   user = context['user']
#   model.authorize_changes!(action, user)
# }

# BabycareSchema  = GraphQL::Schema.define do
#   # Set up the graphql-batch gem
#   use GraphQL::Batch

#   # Set up the graphql-activerecord gem
#   instrument(:field, GraphQL::Models::Instrumentation.new)
# end
