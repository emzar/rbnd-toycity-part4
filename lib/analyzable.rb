module Analyzable
  def average_price(products)
    price_sum = products.reduce(0) { |sum, product| sum + product.price }
    (price_sum / products.length).round(2)
  end

  def print_report(products)
    "Average Price: $#{average_price(products)}"
  end

  %i[brand name].each do |method|
    define_singleton_method("count_by_#{method}") do |products|
      { products.first.public_send("#{method}") => products.size }
    end
  end
end
