Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # TODO: remove me
  field :testField, types.String do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end

  field :allMedicalRecordsByUserId, types[Types::MedicalRecordType] do
    description "return all medical records of an user"

    argument :user_id, !types.Int do
      description "uesr_id"
    end

    resolve ->(obj, args, ctx) {
      MedicalRecord.where(user_id: args[:user_id])
    }
  end

  field :medicalRecordsById, Types::MedicalRecordType do
    description "return one medical record by id"

    argument :id, !types.Int do
      description "uesr_id"
    end

    resolve ->(obj, args, ctx) {
      MedicalRecord.where(id: args[:id]).first
    }

  end
end
