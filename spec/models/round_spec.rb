require 'rails_helper'

RSpec.describe Round, type: :model do
  it "requires a golfer, date, gross score and handicap" do
    golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1234')

    round = Round.new(golfer: golfer, occurred_on: Date.today, gross_score: 20, handicap: 16)
    expect(round.valid?).to be(true)

    %w(golfer occurred_on gross_score handicap).each do |col|
      orig_val = round.send(col)
      round.send("#{col}=", nil)
      expect(round.valid?).to be(false), "Round was still valid when #{col} was set to blank"
      round.send("#{col}=", orig_val)
    end
  end

  context "#next_round" do
    it "returns a round that occurs after the current round" do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1234')

      round1 = Round.create!(golfer: golfer, occurred_on: 5.days.ago, gross_score: 20, handicap: 16)
      round2 = Round.create!(golfer: golfer, occurred_on: 4.days.ago, gross_score: 20, handicap: 16)
      round3 = Round.create!(golfer: golfer, occurred_on: 3.days.ago, gross_score: 20, handicap: 16)

      expect(round1.next_round).to eq(round2)
      expect(round2.next_round).to eq(round3)
      expect(round3.next_round).to be_nil
    end
  end

  context "when printing net score" do
    before(:each) do
      golfer = Golfer.create!(first_name: 'test', last_name: 'golfer', identifier: '1234')
      @round = Round.new(golfer: golfer, occurred_on: Date.today, gross_score: 20, handicap: 16)
    end

    it "prints the net score by adding the handicap and gross score" do
      expect(@round.net_score).to eq(36)
    end

    it "calculates the net score using a passed in handicap" do
      expect(@round.net_score(14)).to eq(34)
    end

    it "prints the gross score when the handicap is nil" do
      @round.handicap = nil
      expect(@round.net_score).to eq(@round.gross_score)
    end

    it "returns nil when the gross score is nil" do
      @round.gross_score = nil
      expect(@round.net_score).to be_nil
    end
  end

  context "when setting net score" do
    it "stores the gross score and handicap" do
      round = Round.new(handicap: 16, net_score: 36)
      expect(round.net_score).to eq(36)
      expect(round.gross_score).to eq(20)
    end
  end
end
