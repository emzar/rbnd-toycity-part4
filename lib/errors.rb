class ProductNotFoundError < StandardError
  def initialize(id)
    super("There is no product with id ##{id}")
  end
end
