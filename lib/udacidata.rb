require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  PRODUCT_KEYS = %i[id brand name price]
  METHODS_TO_FIELDS = { brand: :brand, name: :product }

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

  def self.find(index)
    product_from_csv(csv_table[index])
  end

  def self.destroy(index)
    table = CSV.table(data_path)
    row = table.delete(index - 1)
    File.open(data_path, 'w') { |f| f.write(table.to_csv) }
    product_from_csv(row.fields)
  end

  METHODS_TO_FIELDS.each do |method, field_name|
    define_singleton_method("find_by_#{method}") do |value|
      product_from_csv(CSV.table(data_path).find { |row| row[field_name] == value }.fields)
    end
  end

  def self.where(opts = {})
    option = opts.keys.first
    products = CSV.table(data_path).select { |row| row[option] == opts[option] }
    products.map { |row| product_from_csv(row.fields) }
  end

  def update(opts = {})
    opts.each { |key, value| self.send("#{key}=", value) }
    self
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
