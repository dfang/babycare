# frozen_string_literal: true

class DoctorsController < InheritedResources::Base
  before_action -> { authenticate_user!(force: true) }
  include Wicked::Wizard
  steps :basic, :career, :finished

  # before_action ->{ authenticate_user!( force: true ) }, except: [ :apply, :new, :create ]
  # custom_actions :resource => :status

  before_action :set_doctor, only: %i[status show edit update destroy online offline contract]
  before_action :check_is_verified_doctor, only: %i[reservations index]

  def apply
    redirect_to new_doctor_path
  end

  def profile
    # @resource = current_user.medical_records.first
  end

  def status
    Rails.logger.info 'status'
  end

  def sign
    if current_user.has_valid_contracts?
      redirect_to doctors_status_path and return
    else
      @contract = Contract.new
    end
  end

  def contract
    if request.post?
      # binding.pry
      @contract = Contract.new(contract_params)
      @contract.user = current_user
      @bank_account = BankAccount.new(bank_account_params)
      @bank_account.user = current_user
      redirect_to doctors_contract_path and return if @contract.save && @bank_account.save
      render :sign
    else
      @contract = current_user.contracts.last
      @bank_account = current_user.bank_accounts.last
    end

  end

  def new
    if current_user && current_user.doctor.present?
      @doctor = current_user.doctor
      if current_user.has_valid_contracts?
        redirect_to doctors_status_path and return
      else
        if @doctor.verified?
          redirect_to(wizard_path(:finished)) and return
        else
          redirect_to(wizard_path(:career)) and return
        end
      end
    else
      @doctor = current_user.build_doctor
      redirect_to(wizard_path(:basic)) and return
    end
  end

  def index
    p 'doctor index'
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
    @doctor.update(aasm_state: :verified) unless Rails.env.production?

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
    @doctor.update(aasm_state: :verified) unless Rails.env.production?

    respond_to do |format|
      if @doctor.update(doctor_params.except(:captcha))
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
        # render_wizard
        Rails.logger.info @doctor.errors.messages
        format.html { render_wizard }
        # format.json { render json: @doctor.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_wizard_path
    status_doctor_path
  end

  private

  def check_is_verified_doctor
    if current_user.doctor.nil?
      flash[:error] = '你还没提交资料申请我们的签约医生'
      redirect_to(global_denied_path) && return
    end

    unless current_user.verified_doctor?
      redirect_to(doctors_status_path) && return
    end
  end

  def set_doctor
    @doctor = if current_user.doctor.present?
                current_user.doctor
              else
                Doctor.new
              end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def doctor_params
    # params.require(:doctor).permit(:name, :gender, :age, :hospital, :location, :lat, :long, :verified, :date_of_birth, :mobile_phone, :remark, :id_card_num, :id_card_front, :id_card_back, :license, :job_title)
    params.require(:doctor).permit!
  end

  def contract_params
    params.require(:contract).permit(:start_at, :end_at, :months)
                                     # :bank_account, {:bank_account => [:account_name, :bank_branch_name, :account_number]})
    # params.require(:contract).permit!
  end

  def bank_account_params
    params.require(:contract).permit(:bank_account, {:bank_account => [:account_name, :bank_name, :account_number]})[:bank_account]
  end
end
