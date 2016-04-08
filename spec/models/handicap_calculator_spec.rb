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

  context "when a player is new" do
    before(:each) do
      golfer = Golfer.create!(first_name: 'New', last_name: 'Player', identifier: '0', handicap: 20)
      @calculator = HandicapCalculator.new(golfer)
      @calculator.post_score(37, 10.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(20)
    end

    it "makes no change when there is only 1 or 2 rounds" do
      @calculator.post_score(37, 9.days.ago)

      expect(@calculator.golfer.rounds.count).to be(2)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(20)
    end

    it "counts 2 of the last 3 rounds" do
      @calculator.post_score(37, 9.days.ago)
      @calculator.post_score(37, 8.days.ago)

      expect(@calculator.golfer.rounds.count).to be(3)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 2 of the last 4 rounds" do
      @calculator.post_score(35, 9.days.ago)
      @calculator.post_score(37, 8.days.ago)
      @calculator.post_score(37, 7.days.ago)

      expect(@calculator.golfer.rounds.count).to be(4)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 3 of the last 5 rounds" do
      @calculator.post_score(32, 9.days.ago)
      @calculator.post_score(37, 8.days.ago)
      @calculator.post_score(37, 7.days.ago)
      @calculator.post_score(37, 6.days.ago)

      expect(@calculator.golfer.rounds.count).to be(5)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 3 of the last 6 rounds" do
      @calculator.post_score(32, 9.days.ago)
      @calculator.post_score(32, 8.days.ago)
      @calculator.post_score(37, 7.days.ago)
      @calculator.post_score(37, 6.days.ago)
      @calculator.post_score(37, 5.days.ago)

      expect(@calculator.golfer.rounds.count).to be(6)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 4 of the last 7 rounds" do
      @calculator.post_score(32, 9.days.ago)
      @calculator.post_score(32, 8.days.ago)
      @calculator.post_score(37, 7.days.ago)
      @calculator.post_score(37, 6.days.ago)
      @calculator.post_score(37, 5.days.ago)
      @calculator.post_score(37, 4.days.ago)

      expect(@calculator.golfer.rounds.count).to be(7)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 4 of the last 8 rounds" do
      @calculator.post_score(32, 9.days.ago)
      @calculator.post_score(32, 8.days.ago)
      @calculator.post_score(32, 7.days.ago)
      @calculator.post_score(37, 6.days.ago)
      @calculator.post_score(37, 5.days.ago)
      @calculator.post_score(37, 4.days.ago)
      @calculator.post_score(37, 3.days.ago)

      expect(@calculator.golfer.rounds.count).to be(8)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end

    it "counts 5 of the last 9 rounds" do
      @calculator.post_score(32, 9.days.ago)
      @calculator.post_score(32, 8.days.ago)
      @calculator.post_score(32, 7.days.ago)
      @calculator.post_score(37, 6.days.ago)
      @calculator.post_score(37, 5.days.ago)
      @calculator.post_score(37, 4.days.ago)
      @calculator.post_score(37, 3.days.ago)
      @calculator.post_score(37, 2.days.ago)

      expect(@calculator.golfer.rounds.count).to be(9)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(20).to(19)
    end
  end

  context "when changing the handicap after each posted score" do
    it "should update to the correct handicap" do
      golfer = Golfer.create!(first_name: 'New', last_name: 'Player', identifier: '0', handicap: 15)
      @calculator = HandicapCalculator.new(golfer)

      @calculator.post_score(40, 10.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(15)

      @calculator.post_score(36, 9.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(15)

      @calculator.post_score(32, 8.days.ago)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(15).to(13)

      @calculator.post_score(40, 7.days.ago)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(13).to(10)

      @calculator.post_score(30, 6.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(10)

      @calculator.post_score(28, 5.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(10)

      @calculator.post_score(28, 4.days.ago)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(10).to(11)

      @calculator.post_score(32, 3.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(11)

      @calculator.post_score(32, 2.days.ago)
      expect { @calculator.update_handicap! }.to change(@calculator.golfer, :handicap).from(11).to(12)

      @calculator.post_score(30, 1.days.ago)
      expect { @calculator.update_handicap! }.to_not change(@calculator.golfer, :handicap).from(12)
    end
  end

  context "when removing a round" do
    it "should recalculate the handicap" do
      golfer = Golfer.create!(first_name: 'New', last_name: 'Player', identifier: '0', handicap: 20)
      @calculator = HandicapCalculator.new(golfer)
      @calculator.post_score(37, 10.days.ago).update_handicap!
      @calculator.post_score(32, 9.days.ago).update_handicap!
      @calculator.post_score(32, 8.days.ago).update_handicap!
      @calculator.post_score(32, 7.days.ago).update_handicap!
      @calculator.post_score(37, 6.days.ago).update_handicap!
      @calculator.post_score(37, 5.days.ago).update_handicap!
      @calculator.post_score(37, 4.days.ago).update_handicap!
      @calculator.post_score(37, 3.days.ago).update_handicap!
      @calculator.post_score(37, 2.days.ago).update_handicap!
      expect { @calculator.post_score(40, 1.days.ago).update_handicap! }.to change(@calculator.golfer, :handicap).from(18).to(17)

      expect { @calculator.remove_score(@calculator.golfer.rounds.recent.first.id) }.to change(@calculator.golfer, :handicap).from(17).to(18)
    end
  end
end
