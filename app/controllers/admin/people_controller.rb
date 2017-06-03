# frozen_string_literal: true

class Admin::PeopleController < Admin::BaseController
  private

    def person_params
      params.require(:person).permit!
    end
end
