class DoctorsController < InheritedResources::Base
  before_filter ->{ authenticate_user!( force: true ) }
  include Wicked::Wizard
  steps :basic, :career, :finished

  # before_filter ->{ authenticate_user!( force: true ) }, except: [ :apply, :new, :create ]
  # custom_actions :resource => :status

  before_action :set_doctor, only: [:show, :edit, :update, :destroy, :online, :offline]

  def apply
  end

  def profile
    # @resource = current_user.medical_records.first
  end

  def status
    Rails.logger.info 'aaaa'
  end

  def new
    # jump_to(:basic)

    if current_user && current_user.doctor.present?
      @doctor = current_user.doctor
      jump_to(:basic)
      if @doctor.verified?
        # redirect_to status_doctor_path(@doctor)
        jump_to(:finish)
      end
    else
      jump_to(:basic)
      # @doctor = Doctor.new
    end
  end

  def show
    # Rails.logger.info params[:action]
    # Rails.logger.info 'aaaa'
    # if params.key?(:action) && pa
    # @user = current_user
    # case step
    # when :find_friends
    #   @friends = @user.find_friends
    # end
    render_wizard
  end

  # POST /doctors
  # POST /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)
    @doctor.user = current_user

    respond_to do |format|
      if @doctor.save
        # format.html { redirect_to status_doctor_path(@doctor), notice: 'Doctor was successfully created.' }
        format.html { redirect_to next_wizard_path, notice: 'Doctor was successfully created.' }
        # format.json { render :status, status: :created, location: @doctor }
      else
        format.html { render :new }
        # format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /doctors/1
  # PATCH/PUT /doctors/1.json
  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        case step
        when :basic
          format.html { redirect_to next_wizard_path }
        when :career
          format.html { redirect_to next_wizard_path }
        when :finish
          format.html
        end

        # format.html { redirect_to @doctor, notice: 'Doctor was successfully updated.' }

        # format.html { redirect_to apply_doctors_path, notice: 'Doctor was successfully created.' }
        # format.json { render :show, status: :ok, location: @doctor }
      else
        render_wizard
        # format.html { render :edit }
        # format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_wizard_path
    status_doctor_path
  end


  private
    def set_doctor
      if current_user.doctor.present?
        @doctor = current_user.doctor
      # elsif params.key?(:id)
      #   @doctor = Doctor.find(params[:id])
      else
        @doctor = Doctor.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_params
      # params.require(:doctor).permit(:name, :gender, :age, :hospital, :location, :lat, :long, :verified, :date_of_birth, :mobile_phone, :remark, :id_card_num, :id_card_front, :id_card_back, :license, :job_title)
      params.require(:doctor).permit!
    end
end
