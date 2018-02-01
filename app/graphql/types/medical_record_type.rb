Types::MedicalRecordType = GraphQL::ObjectType.define do
  name "MedicalRecord"
  backed_by_model :MedicalRecord do
    attr :name
  end
end
