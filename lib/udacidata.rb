require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  def self.create(opts = {})
    product = Product.new(opts)
    CSV.open(data_path, "ab") do |csv|
      csv << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  def self.all
    CSV.open(data_path, "r").read.map do |row|
      Product.new(id: row[0], brand: row[1], name: row[2], price: row[3])
    end
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end
end
