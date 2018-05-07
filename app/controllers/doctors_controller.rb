# frozen_string_literal: true

class DoctorsController < InheritedResources::Base
  before_action :authenticate_user!
  helper_method :current_doctor

  include Wicked::Wizard
  steps :basic, :career

  before_action :check_legality, only: %i[index reservations]
  before_action :set_doctor, only: %i[show update sign contract]

  def apply
    redirect_to new_doctor_path
  end

  def profile
  end

  # 申请，审核状态, 合同过期页
  def status
    redirect_to(wizard_path(:career)) and return if current_doctor && current_doctor.id_card_num.blank?
    Rails.logger.info 'status'
  end

  def sign
    if current_doctor.has_valid_contracts?
      redirect_to doctors_status_path and return
    else
      @contract = Contract.new
    end
  end

  def contract
    if request.post?
      @contract = Contract.new(contract_params)
      @contract.doctor = current_doctor
      @bank_account = BankAccount.new(bank_account_params)
      @bank_account.user = current_user
      redirect_to doctors_contract_path and return if @contract.save && @bank_account.save
      render :sign
    else
      @contract = current_doctor.contracts.last
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
    Rails.logger.info "医生个人中心"
  end

  def show
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
    @doctor.verify! unless Rails.env.production?

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
      else
        Rails.logger.info @doctor.errors.messages
        format.html { render_wizard }
      end
    end
  end

  def finish_wizard_path
    doctors_status_path
  end

  private

  def check_legality
    redirect_to doctors_status_path unless current_doctor && current_doctor.has_valid_contracts?
  end

  def set_doctor
    @doctor = if current_doctor.present?
                current_doctor
              else
                Doctor.new
              end
  end

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

  def current_doctor
    @current_doctor ||= current_user.doctor if current_user.doctor.present?
  end
end
