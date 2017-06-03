# frozen_string_literal: true

module ClientStateMachine
  module Reservation
    extend ActiveSupport::Concern

    included do
      include AASM
      include Wisper::Publisher

      after_create_commit do
        broadcast(:reservation_create_successful, self)
      end

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
          transitions from: %i[pending reserved], to: :archived
        end

        event :rate, after_commit: :after_rated! do
          transitions from: :paid, to: :rated
        end

        event :cancel, after_commit: :after_cancelled! do
          transitions from: %i[reserved prepaid pending], to: :cancelled
        end

        event :overdue, after_commit: :after_overdue! do
          transitions from: :pending, to: :overdued
        end
      end

      # aasm guards
      def can_be_reserved?
        # self.user_b.present? && self.reservation_location.present? && self.reservation_time.present? && self.reservation_phone.present?
        # must be prepaid
        true
      end

      # # aasm transaction callbacks
      def after_prepaid!
        p 'broadcast reservation_prepay_successful'
        broadcast(:reservation_prepay_successful, self)

        # user prepay and send sms to notify doctor prepaid
        # params1 = [ self.doctor_user_name, self.reserved_time, self.reserved_location ]
        # params2 = [ self.patient_user_name, self.reserved_time, self.reserved_location]
        # SmsNotifyUserWhenPrepaidJob.perform_now(self.patient_user_phone, params1)
        # SmsNotifyDoctorWhenPrepaidJob.perform_now(self.doctor_user_phone, params2)
      end

      def after_reserved!
        broadcast(:reservation_reserve_successful, self)
      end

      def after_diagnosed!
        broadcast(:reservation_diagnose_successful, self)
      end

      def after_paid!
        broadcast(:reservation_pay_successful, self)
      end

      def after_rated!
        broadcast(:reservation_rate_successful, self)
      end
    end
  end
end
