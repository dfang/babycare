# frozen_string_literal: true

class Admin::SymptomsController < Admin::BaseController
  private

    def symptom_params
      params.require(:symptom).permit!
    end
end
