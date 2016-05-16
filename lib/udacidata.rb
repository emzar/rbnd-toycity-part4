require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  PRODUCT_KEYS = %i[id brand name price]

  create_finder_methods :id, :brand, :name

  def self.create(opts = {})
    find(opts[:id])
  rescue ProductNotFoundError
    opts[:price] = opts[:price].to_f
    Product.new(opts).tap do |product|
      CSV.open(data_path, 'ab') do |csv|
        csv << [product.id, product.brand, product.name, product.price]
      end
    end
  end

  def self.all
    products_from_array(csv_array.drop(1))
  end

  def self.first(n = 1)
    products_from_array(csv_array.drop(1).first(n))
  end

  def self.last(n = 1)
    products_from_array(csv_array.last(n))
  end

  def self.find(id)
    find_by_id(id)
  end

  def self.destroy(id)
    table = csv_table
    table.each_with_index do |row, index|
      if row[:id] == id
        table.delete(index)
        save!(table)
        return product_from_array(row.fields)
      end
    end
    raise ProductNotFoundError.new(:id, id)
  end

  def self.where(opts = {})
    option = opts.keys.first
    key = Udacidata.csv_row_key(option)
    products = csv_table.select { |row| row[key] == opts[option] }
    products.map { |row| product_from_array(row.fields) }
  end

  def update(opts = {})
    self.tap do |product|
      table = Udacidata.csv_table
      opts.each do |key, value|
        product.public_send("#{key}=", value)
        table[product.id - 1][Udacidata.csv_row_key(key)] = value
      end
      Udacidata.save!(table)
    end
  end

  private

  def self.data_path
    File.dirname(__FILE__) + "/../data/data.csv"
  end

  def self.csv_array
    CSV.read(data_path, converters: :numeric)
  end

  def self.csv_table
    CSV.table(data_path, converters: :numeric)
  end

  def self.products_from_array(table)
    products = table.map { |row| product_from_array(row) }
    products.size == 1 ? products.first : products
  end

  def self.product_from_array(row)
    Product.new(PRODUCT_KEYS.zip(row).to_h)
  end

  def self.csv_row_key(key)
    key == :name ? :product : key
  end

  def self.save!(table)
    File.open(data_path, 'w') { |f| f.write(table.to_csv) }
  end
end
