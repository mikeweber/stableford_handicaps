require 'rails_helper'

RSpec.describe HandicapCalculator, type: :model do
  it "adds a round to a golfer's history" do
    golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 5)
    round_date = Date.today
    calculator = HandicapCalculator.new(golfer)

    expect {
      calculator.post_score(30, round_date)
    }.to change(golfer.rounds, :count).by(1)
    last_round = golfer.rounds.last
    expect(last_round.net_score).to eq(30)
    expect(last_round.gross_score).to eq(25)
    expect(last_round.occurred_on).to eq(round_date)
  end

  it "calculates the average net score of the best 5 rounds from the 10 most recent rounds" do
    golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
    calculator = HandicapCalculator.new(golfer)

    [36, 36, 36, 36, 36, 37, 37, 37, 37, 37, 35, 35, 35, 35, 35, 35, 35].each.with_index do |score, i|
      calculator.post_score(score, i.days.ago)
    end
    expect(calculator.net_average).to eql(37.0)
  end

  context "when updating the golfer's handicap" do
    it "adjusts the golfer's handicap up when the average is 34" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [33, 34, 33, 34, 33, 34, 33, 34, 33, 34].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to eql(34.0)
      expect { calculator.update_handicap! }.to change(calculator.golfer, :handicap).from(7).to(8)
    end

    it "adjusts the golfer's handicap up when the average is below 34" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [33, 34, 33, 34, 33, 34, 33, 34, 33, 33].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to be < 34.0
      expect { calculator.update_handicap! }.to change(calculator.golfer, :handicap).from(7).to(8)
    end

    it "adjusts the golfer's handicap up twice when the average is below 33" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [33, 32, 33, 32, 33, 32, 33, 32, 32, 31].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to be < 33.0
      expect { calculator.update_handicap! }.to change(calculator.golfer, :handicap).from(7).to(9)
    end

    it "adjusts the golfer's handicap down twice when the average is above 37.5" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [40, 37, 33, 37, 33, 37, 33, 37, 33, 35].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to be >= 37.5
      expect { calculator.update_handicap! }.to change(calculator.golfer, :handicap).from(7).to(5)
    end

    it "adjusts the golfer's handicap down when the average is above 36.5" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [33, 37, 33, 37, 33, 37, 33, 37, 33, 35].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to be >= 36.5
      expect { calculator.update_handicap! }.to change(calculator.golfer, :handicap).from(7).to(6)
    end

    it "does not change the golfer's handicap when the average is between 34 and 36.5" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1', handicap: 7)
      calculator = HandicapCalculator.new(golfer)

      [33, 37, 33, 37, 33, 37, 33, 37, 33, 34].each.with_index do |score, i|
        calculator.post_score(score, i.days.ago)
      end
      expect(calculator.net_average).to be < 36.5
      expect(calculator.net_average).to be > 34
      expect { calculator.update_handicap! }.to_not change(calculator.golfer, :handicap).from(7)
    end
  end
end
