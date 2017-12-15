# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def cities
    @cities = City.where(pinyin: 'wuhan')
  end

  def hospitals
    city = City.find_by(pinyin: params[:city])
    @hospitals = Hospital.where(city: city) if city.present?
  end

  def doctors
    hospital = Hospital.find_by(id: params[:hospital])
    @doctors = Doctor.where(hospital: hospital) if hospital.present?
  end
end
