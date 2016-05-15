class ProductNotFoundError < StandardError
  def initialize(method, value)
    super("There is no product with #{method}: #{value}")
  end
end
