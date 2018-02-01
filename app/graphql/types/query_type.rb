Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :medicalrecordById, Types::MedicalRecordType do
    description "An example field added by the generator"
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      MedicalRecord.find(args[:id])
    }
  end

  field :allMedicalRecords, types[Types::MedicalRecordType] do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      MedicalRecord.all
    }
  end

  field :allDoctors, types[Types::DoctorType] do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      Doctor.all
    }
  end

  field :doctorById, Types::DoctorType do
    description "An example field added by the generator"
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Doctor.find(args[:id])
    }
  end

  field :authentication, Types::AuthenticationType do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end
end
