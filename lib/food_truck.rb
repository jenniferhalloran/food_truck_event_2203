class FoodTruck
  attr_reader :name,
              :inventory

  def initialize(name)
    @name = name
    @inventory = {}
  end


end
