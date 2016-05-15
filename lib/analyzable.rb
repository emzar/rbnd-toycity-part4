module Analyzable
  def average_price(products)
    price_sum = products.reduce(0) { |sum, product| sum + product.price }
    (price_sum / products.length).round(2)
  end

  def print_report(products)
    "Average Price: $#{average_price(products)}\n".tap do |report|
      report << report_by_brand(products)
      report << report_by_name(products)
    end
  end

  %i[brand name].each do |method|
    define_singleton_method("count_by_#{method}") do |products|
      {}.tap do |result|
        products.each do |product|
          value = product.public_send("#{method}")
          result.has_key?(value) ? result[value] += 1 : result[value] = 1
        end
      end
    end

    define_singleton_method("report_by_#{method}") do |products|
      "Inventory by #{method.capitalize}:\n".tap do |report|
        public_send("count_by_#{method}", products).each do |key, value|
          report << "  - #{key}: #{value}\n"
        end
      end
    end
  end
end
