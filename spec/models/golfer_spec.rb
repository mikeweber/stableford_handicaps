require 'rails_helper'

RSpec.describe Golfer, type: :model do
  it "has a first and last name, golfer ID, and handicap" do
    golfer = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: 50, handicap: 2)
    golfer = Golfer.find(golfer.id)

    expect(golfer.first_name).to eq('Tiger')
    expect(golfer.last_name).to eq('Irons')
    expect(golfer.identifier).to eq('50')
    expect(golfer.handicap).to eq(2)
  end

  it "should have a unique identifier" do
    golfer = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: '1', handicap: 2)
    duplicate_golfer = Golfer.new(first_name: 'Tiger', last_name: 'Irons', identifier: '1', handicap: 2)
    expect(duplicate_golfer).to_not be_valid
    duplicate_golfer.identifier = '2'
    expect(duplicate_golfer).to be_valid
  end

  it "should ignore the uniqueness of the identifier when it is '0' or 'guest'" do
    guest_golfer1 = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: '0', handicap: 2)
    guest_golfer2 = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: '0', handicap: 2)
    guest_golfer3 = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: 'guest', handicap: 2)
    guest_golfer4 = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: 'guest', handicap: 2)
  end

  it "returns last name, first name for the full name method" do
    golfer = Golfer.create!(first_name: 'Tiger', last_name: 'Irons', identifier: '0', handicap: 0)
    expect(golfer.full_name).to eq('Irons, Tiger')
  end

  it "returns only the last name when first name is blank" do
    golfer = Golfer.create!(last_name: 'Guest', identifier: '0', handicap: 0)
    expect(golfer.full_name).to eq('Guest')
  end

  it "returns only the first name when last name is blank" do
    golfer = Golfer.create!(first_name: 'Guest', identifier: '0', handicap: 0)
    expect(golfer.full_name).to eq('Guest')
  end
end
