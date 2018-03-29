# frozen_string_literal: true

QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :allMedicalRecordsByUserId, types[MedicalRecordType] do
    description "return all medical records of an user"

    argument :user_id, !types.Int do
      description "uesr_id"
    end

    resolve ->(obj, args, ctx) {
      MedicalRecord.where(user_id: args[:user_id])
    }
  end

  field :medicalRecordById, MedicalRecordType do
    description "return one medical record by id"

    argument :id, !types.Int do
      description "medical id"
    end

    resolve ->(obj, args, ctx) {
      MedicalRecord.where(id: args[:id]).first
    }
  end

  field :unionIdForUserId, types.String do
    argument :id, !types.String do
      description "union_id"
    end

    resolve ->(obj, args, ctx) {
      auth = Authentication.where(unionid: args[:id]).first
      if auth.present?
        auth.user_id.to_s
      else
        ""
      end
    }
  end
end
