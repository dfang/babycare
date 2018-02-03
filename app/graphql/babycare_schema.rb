Dir[File.dirname(__FILE__) + '/types/*.rb'].each {|file| require file }

BabycareSchema = GraphQL::Schema.define do
  query(QueryType)
  mutation(MutationType)

  use GraphQL::Batch
  enable_preloading
end
