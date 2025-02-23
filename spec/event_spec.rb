require './lib/item'
require './lib/food_truck'
require './lib/event'

RSpec.describe Event do
  let(:event) {Event.new("South Pearl Street Farmers Market")}

  let(:food_truck1) {FoodTruck.new("Rocky Mountain Pies")}
  let(:food_truck2) {FoodTruck.new("Ba-Nom-a-Nom")}
  let(:food_truck3) {FoodTruck.new("Palisade Peach Shack") }

  let(:item1) {Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})}
  let(:item2) {Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})}
  let(:item3) {Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
  let(:item4) {Item.new({name: "Banana Nice Cream", price: "$4.25"})}
  let(:item5) {Item.new({name: 'Onion Pie', price: '$25.00'})}

  it "exists" do
    expect(event).to be_a(Event)
  end

  it "has readable attributes" do
    expect(event.name).to eq("South Pearl Street Farmers Market")
    expect(event.food_trucks).to eq([])
  end

  it "can add food trucks" do
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.food_trucks).to eq([food_truck1, food_truck2, food_truck3])
  end

  it "can return the names of the food trucks" do
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.food_truck_names).to eq(["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
  end

  it "can list good trucks that sell a given item" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.food_trucks_that_sell(item1)).to eq([food_truck1, food_truck3])
    expect(event.food_trucks_that_sell(item4)).to eq([food_truck2])
  end

  it "can list food truck's potential revenue" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(food_truck1.potential_revenue).to eq(148.75)
    expect(food_truck2.potential_revenue).to eq(345.00)
    expect(food_truck3.potential_revenue).to eq(243.75)
  end

  it "can provide a sorted item list" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    food_truck3.stock(item3, 10)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.sorted_item_list).to eq([item2, item4, item1, item3])
  end

  it "can list overstocked items" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    food_truck3.stock(item3, 10)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.overstocked_items).to eq([item1])
  end

  it "can list total inventory" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    food_truck3.stock(item3, 10)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expected_hash = { item1 => {quantity: 100,
                            food_trucks: [food_truck1, food_truck3]},
                      item2 => {quantity: 7,
                            food_trucks: [food_truck1]},
                      item4 => {quantity: 50,
                            food_trucks: [food_truck2]},
                      item3 => {quantity: 35,
                            food_trucks: [food_truck2, food_truck3]}
                          }
    expect(event.total_inventory).to eq(expected_hash)
  end

  it "can list the date in the correct format" do

    expect(event.date).to eq("26/04/2022")

    date = double("past date")
    allow(event).to receive(:date).and_return("24/02/2020")

    expect(event.date).to eq("24/02/2020")
  end

  it "can sell items" do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)

    expect(event.sell(item1, 200)).to eq(false)
    expect(event.sell(item5, 1)).to eq(false)
    expect(event.sell(item4, 5)).to eq(true)
    expect(food_truck2.check_stock(item4)).to eq(45)
    expect(event.sell(item1, 40)).to eq(true)
    expect(food_truck1.check_stock(item1)).to eq(0)
    expect(food_truck3.check_stock(item1)).to eq(60)


  end

end
