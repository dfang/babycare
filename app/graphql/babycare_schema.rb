# GraphQL::Models.model_to_graphql_type = -> (model_class) { "#{model_class.name}Graph".safe_constantize }

# GraphQL::Models.model_from_id = -> (id, context) {
#   model_type, model_id = NodeHelpers.decode_id(id)
#   model_type.find(model_id)
# }

# GraphQL::Models.id_for_model = -> (model_type_name, model_id) {
#   NodeHelpers.encode_id(model_type_name, model_id)
# }

BabycareSchema = GraphQL::Schema.define do
  # mutation(Types::MutationType)
  query(Types::QueryType)

  lazy_resolve(Promise, :sync)

  # Deprecated graphql-batch setup `instrument(:query, GraphQL::Batch::Setup)`, replace with `use GraphQL::Batch`
  # instrument(:query, GraphQL::Batch::Setup)
  use GraphQL::Batch

  instrument(:field, GraphQL::Models::Instrumentation.new)
end
