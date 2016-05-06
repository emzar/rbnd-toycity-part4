require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  brands = ["Crayola", "Lego", "Nintendo", "Fisher-Price", "Hasbro"]
  data_path = File.dirname(__FILE__) + "/../data/data.csv"
  CSV.open(data_path, "wb") do |csv|
    10.times do |id|
      csv << [id + 1, brands.sample, Faker::Commerce.product_name, Faker::Commerce.price]
    end
  end
end
