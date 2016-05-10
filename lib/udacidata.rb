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
    CSV.open(data_path, 'r').read.drop(1).map { |row| Product.new(product_options(row)) }
  end

  def self.first(n = 1)
    products = []
    n.times do
      row = CSV.open(data_path, 'r', headers:true).shift
      products << product_from_csv(row)
    end
    return products.first if n == 1
    products
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

  def self.product_options(row)
    PRODUCT_KEYS.zip(row).to_h
  end

  def self.product_from_csv(row)
    opts = row.to_hash.map { |k, v| [PRODUCT_MAPPINGS[k], v] }.to_h
    Product.new(opts)
  end
end
