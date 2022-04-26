require './lib/item'
require './lib/food_truck'
require './lib/event'

RSpec.describe Event do
  let(:event) {Event.new("South Pearl Street Farmers Market")}

  it "exists" do
    expect(event).to be_a(Event)
  end

  it "has readable attributes" do
    expect(event.name).to eq("South Pearl Street Farmers Market")
    expect(event.food_trucks).to eq([])
  end

end
