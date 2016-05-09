require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  PRODUCT_KEYS = %i[id brand name price]

  def self.create(opts = {})
    product = Product.new(opts)
    CSV.open(data_path, 'ab') do |csv|
      csv << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  def self.all
    CSV.open(data_path, 'r').read.drop(1).map { |row| Product.new(PRODUCT_KEYS.zip(row).to_h) }
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end
end
