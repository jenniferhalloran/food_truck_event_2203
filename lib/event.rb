require 'date'

class Event
  attr_reader :name,
              :food_trucks,
              :date

  def initialize(name)
    @name = name
    @food_trucks = []
    @date = date_string
  end

  def add_food_truck(food_truck)
    @food_trucks << food_truck
  end

  def food_truck_names
   @food_trucks.map { |food_truck| food_truck.name}
  end

  def food_trucks_that_sell(item)
    @food_trucks.select { |food_truck| food_truck.inventory.keys.include?(item) }
  end

  def sorted_item_list
    inventory = @food_trucks.flat_map { |food_truck| food_truck.inventory.keys }.uniq
    inventory.sort_by { |item| item.name}
  end

  def overstocked_items
    total_inventory.map do |item, stock_info|
      item if stock_info[:quantity] > 50 && stock_info[:food_trucks].length > 1
    end.compact
  end

  def total_inventory
    inventory_hash = {}
    @food_trucks.map do |food_truck|
      food_truck.inventory.map do |item, quantity|
        if inventory_hash[item].nil?
          inventory_hash[item] = {quantity: quantity,
                                  food_trucks: [food_truck]}
        else
          inventory_hash[item][:quantity] += quantity
          inventory_hash[item][:food_trucks] << food_truck
        end
      end
    end
    inventory_hash
  end

  def date_string
    today_date = Date.today.strftime("%d/%m/%Y")
  end

  def sell(item, quantity)
    if total_inventory[item].nil? || total_inventory[item][:quantity] < quantity
      false
    else
    food_trucks_with_item =  @food_trucks.select do |food_truck|
        food_truck.inventory.keys.include?(item)
      end
      food_trucks_with_item.map do |food_truck|
        food_truck.inventory[item] -= quantity
      end
      true
    end
  end
end

##It should look through the FoodTrucks in the order they were added and
##sell the item from the first FoodTruck with that item in stock. If that
##FoodTruck does not have enough stock to satisfy the given quantity, the
## FoodTruck's entire stock of that item will be depleted, and the remaining
##quantity will be sold from the next food_truck with that item in stock. It
##will follow this pattern until the entire quantity requested has been sold.
