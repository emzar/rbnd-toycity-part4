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
    products_from_csv(csv_table.drop(1))
  end

  def self.first(n = 1)
    products_from_csv(csv_table.drop(1).first(n))
  end

  def self.last(n = 1)
    products_from_csv(csv_table.last(n))
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

  def self.csv_table
    CSV.read(data_path)
  end

  def self.products_from_csv(table)
    products = table.map { |row| product_from_csv(row) }
    products.size == 1 ? products.first : products
  end

  def self.product_from_csv(row)
    Product.new(PRODUCT_KEYS.zip(row).to_h)
  end
end
