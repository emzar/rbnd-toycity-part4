require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  PRODUCT_CSV_HEADERS = %w[id brand product price]
  PRODUCT_KEYS = %i[id brand name price]
  PRODUCT_MAPPINGS = PRODUCT_CSV_HEADERS.zip(PRODUCT_KEYS).to_h

  def self.create(opts = {})
    product = Product.new(opts)
    CSV.open(data_path, 'ab') do |csv|
      csv << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  def self.all
    CSV.read(data_path, headers:true).map { |row| product_from_csv(row) }
  end

  def self.first(n = 1)
    products = []
    csv = CSV.open(data_path, 'r', headers:true)
    n.times { products << product_from_csv(csv.shift) }
    n == 1 ? products.first : products
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

  def self.product_from_csv(row)
    Product.new(row.to_hash.map { |k, v| [PRODUCT_MAPPINGS[k], v] }.to_h)
  end
end
