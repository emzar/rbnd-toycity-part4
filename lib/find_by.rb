class Module
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      find_method = %Q{
        def find_by_#{attribute}(value)
          csv_row = csv_table.find { |row| row[csv_row_key(:#{attribute})] == value }
          raise ProductNotFoundError.new(:#{attribute}, value) unless csv_row
          product_from_array(csv_row.fields)
        end
      }
      Udacidata.instance_eval(find_method)
    end
  end
end
