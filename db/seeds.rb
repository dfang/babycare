# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# rake region:download
# rake region:import

# require 'factory_girl_rails'
# require 'database_cleaner'

# p 'Cleaning database .......'
# DatabaseCleaner.strategy = :truncation
# DatabaseCleaner.clean

# Reservation.delete_all
# Doctor.delete_all

# FactoryGirl.create(:authentication1)
# FactoryGirl.create(:authentication2)
# FactoryGirl.create(:doctor)

# 20.times do
#   FactoryGirl.create(:pending_reservations)
# end

# 5.times do
#   FactoryGirl.create(:reserved_reservations)
# end

p 'Creating symptoms'
require_relative './seeds/symptoms.rb'

p 'Creating doctor test data'
require_relative './seeds/doctor.rb'

p 'Creating examination test data'
require_relative './seeds/examination.rb'

p 'Done .....'

# City.find_or_create_by(name: "武汉市", pinyin: "wuhan")
