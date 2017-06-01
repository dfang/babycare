module ClientStateMachine
  module Reservation
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm do
        state :pending, initial: true
        state :reserved, :prepaid, :diagnosed, :paid, :rated, :archived, :overdued, :cancelled

        event :prepay, after_commit: :after_prepaid! do
          transitions from: :pending, to: :prepaid
        end

        event :reserve, after_commit: :after_reserved! do
          transitions from: :prepaid, to: :reserved, guard: :can_be_reserved?
        end

        event :diagnose, after_commit: :after_diagnosed! do
          transitions from: :prepaid, to: :diagnosed
        end

        event :pay, after_commit: :after_paid! do
          transitions from: :diagnosed, to: :paid
        end

        event :unreserve do
          transitions from: :reserved, to: :pending
        end

        event :archive do
          transitions from: [:pending, :reserved], to: :archived
        end

        event :rate do
          transitions from: :paid, to: :rated
        end

        event :cancel do
          transitions from: [:reserved, :prepaid, :pending], to: :cancelled
        end

        event :overdue do
          transitions from: :reserved, to: :overdued
        end
      end

      # aasm guards
      def can_be_reserved?
        # self.user_b.present? && self.reservation_location.present? && self.reservation_time.present? && self.reservation_phone.present?
        # must be prepaid
        true
      end

      # # aasm transaction callbacks
      def after_reserved!
        # broadcast(:reservation_is_reserved, self.id)
        params = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
        SmsNotifyUserWhenReservedJob.perform_now(self.patient_user_phone, params)
      end

      def after_prepaid!
        # broadcast(:reservation_is_prepaid, self.id)

        # user prepay and send sms to notify doctor prepaid
        # params1 = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
        # params2 = [ self.patient_user_name, self.reserved_time, self.reserved_location]
        # SmsNotifyUserWhenPrepaidJob.perform_now(self.patient_user_phone, params1)
        # SmsNotifyDoctorWhenPrepaidJob.perform_now(self.doctor_user_phone, params2)
      end

      def after_diagnosed!
        SmsNotifyUserWhenDiagnosedJob.perform_now(self.patient_user_phone, Settings.sms_templates.notify_user_when_diagnosed)
      end

      def after_paid!
        params = [self.patient_user_name]
        SmsNotifyDoctorWhenPaidJob.perform_now(self.doctor_user_phone, params)

        ActiveRecord::Base.transaction do
          # increase doctor's income
          amount = self.prepay_fee.to_f + self.pay_fee.to_f

          source = (pay_fee.nil? || pay_fee.zero?) ? :online_consult : :offline_consult

          # increase doctor's wallet unwithdrawable amount
          doctor_user.increase_income(amount, source, self.id)
        end
      end

    end
  end
end
