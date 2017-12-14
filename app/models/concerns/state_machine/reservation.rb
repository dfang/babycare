# frozen_string_literal: true

module StateMachine
  module Reservation
    extend ActiveSupport::Concern

    included do
      include AASM
      include Wisper.model

      aasm do
        state :to_prepay, initail: true
        state :prepaid, :to_examine, :to_consult, :consulting, :to_pay, :paid, :cancelled

        event :prepay, after: :after_prepaid do
          transitions from: :to_prepay, to: :prepaid
        end

        event :reserve_to_examine, after: :after_reserved_to_examine do
          transitions from: :prepaid, to: :to_examine
        end

        event :reserve_to_consult, after: :after_reserved_to_consult do
          transitions from: :prepaid, to: :to_consult
        end

        event :upload_examination, after: :after_examine_to_consult do
          transitions from: :to_examine, to: :to_consult
        end

        event :scan_qrcode, after: :afer_scan_qrcode do
          transitions from: :to_consult, to: :consulting
        end

        event :diagnose, after: :after_diagnosed do
          transitions from: :consulting, to: :to_pay
        end

        event :pay, after: :after_paid do
          transitions from: :to_pay, to: :paid
        end

        event :cancel, after: :after_canceled do
          transitions from: %i[to_prepay prepaid], to: :cancelled
        end
      end

      # aasm transaction callbacks
      def after_prepaid
        broadcast(:after_prepaid, self)
      end

      def after_reserved_to_examine
        broadcast(:after_reserved_to_examine, self)
      end

      def after_reserved_to_consult
        broadcast(:after_reserved_to_consult, self)
      end

      def after_examine_to_consult
        broadcast(:after_examine_to_consult, self)
      end

      def afer_scan_qrcode
        broadcast(:afer_scan_qrcode, self)
      end

      def after_diagnosed
        broadcast(:after_diagnosed, self)
      end

      def after_paid
        broadcast(:after_paid, self)
      end

      def after_canceled
        broadcast(:after_canceled, self)
      end

      def after_rated
        broadcast(:reservation_rated, self)
      end
    end
  end
end
