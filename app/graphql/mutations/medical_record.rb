Mutations::CreateMedicalRecordMutation = GraphQL::Relay::Mutation.define do
  name "CreateMedicalRecord"

  input_field :id,    !types.ID
  input_field :name,  !types.String
  input_field :gender, !types.String
  input_field :weight, !types.String
  input_field :height, !types.String

  # For mutations, you create a mutator definition. This will add the input fields to your
  # mutation, and also return an object that you'll use in the resolver to perform the mutation.
  # The parameters you pass are explained below.
  mutator_definition = GraphQL::Models.define_mutator(self, Employee, null_behavior: :leave_unchanged) do
    attr :name
    attr :gender
    attr :identity_card
    attr :weight
    attr :pulse
    attr :height
  end

  return_field :medical_record, MedicalRecord

  resolve -> (inputs, context) {
    # Fetch (or create) the model that the mutation should change
    model = MedicalRecord.find(inputs[:id])

    # Get the mutator
    mutator = mutator_definition.mutator(model, inputs, context)

    # Call `apply_changes` to update the models. This does not save the changes to the database yet:
    mutator.apply_changes

    # Let's validate the changes. This will raise an exception that can be caught in middleware:
    mutator.validate!

    # Verify that the user is allowed to make the changes. Explained below:
    mutator.authorize!

    # If that passes, let's save the changes and return the result
    mutator.save!

    { medical_record: model }
  }
end
