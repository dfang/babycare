class HomeController < ApplicationController
  def index
  end

  def cities
    @cities = City.where(pinyin: 'wuhan')
  end

  def hospitals
    city = City.find_by(pinyin: params[:city])
    if city.present?
      @hospitals = Hospital.where(city: city)
    end
  end

  def doctors
    hospital = Hospital.find_by(id: params[:hospital])
    if hospital.present?
      @doctors = Doctor.where(hospital: hospital)
    end
  end
end
