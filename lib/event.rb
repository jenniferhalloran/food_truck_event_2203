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

  def food_trucks_that_sell_item(item)
    @food_trucks.select { |food_truck| food_truck.inventory.keys.include?(item) }
  end

  def sell(item, quantity)
    if total_inventory[item].nil? || total_inventory[item][:quantity] < quantity
      false
    else
      need_to_sell = quantity
      food_trucks_that_sell_item(item).map do |food_truck|
          inventory = food_truck.inventory[item]
          food_truck.inventory[item] -= need_to_sell.clamp(0, food_truck.inventory[item])
          need_to_sell -= inventory
          need_to_sell = 0 if need_to_sell <= 0
        end
      true
    end
  end
end
