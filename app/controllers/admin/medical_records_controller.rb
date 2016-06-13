class Admin::MedicalRecordsController < Admin::BaseController
  belongs_to :person
  # defaults :singleton => true
  # nested_belongs_to :person
  # belongs_to :person, optional: true, singleton: true, finder: :find_medical_record
  # before_action :ensure_medical_record, only: [ :edit, :show ]

  def new
    # @resource = parent.medical_records.build
    # @resource.medical_record_images.build
    # @resource.laboratory_examination_images.build
    # @resource.imaging_examination_images.build
    super
  end

  def create
    create! { admin_person_medical_records_path(parent) }
  end

  def update
    update! { admin_person_medical_records_path(parent) }
  end

  private

    def medical_record_params
      # params.require(:medical_record).permit(:onset_date, :chief_complaint, :history_of_present_illness, :past_medical_history, :allergic_history, :personal_history, :family_history, :vaccination_history, :physical_examination, :laboratory_and_supplementary_examinations, :preliminary_diagnosis, :treatment_recommendation, :remarks)
      params.require(:medical_record).permit!
    end

    # def method_for_association_build
    #   :build_medical_record
    # end

    # def build_resource
    #   binding.pry
    #   if params.key?(:action) && params[:action] == "new"
    #     @resource ||= Person.find(params[:person_id]).build_medical_record
    #   else
    #     @resource ||= Person.find(params[:person_id]).build_medical_record(params[:medical_record])
    #   end
    # end

    # def build_resource
    #   get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, *resource_params))
    # end

    # def end_of_association_chain
    #   parent || super
    # end

    # def resource
    #   if params.key?(:person_id)
    #     @resource ||= Person.find(params[:person_id]).medical_record
    #     # binding.pry
    #   else
    #     super
    #   end
    # end

    # def resource
    #   binding.pry
    #   get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_find, params[:id]))
    # end


    # def parent
    #   if params.key?(:person_id)
    #     @parent ||= Person.find(params[:person_id])
    #   # else
    #   #   super
    #   end
    # end

    # def ensure_medical_record
    #   # binding.pry
    #   redirect_to new_admin_person_medical_record_path(parent) if parent.medical_record.nil?
    # end

    # def collection
      # binding.pry
      # super
    # end

    # def find_medical_record
    #   parent.medical_record
    # end

end
