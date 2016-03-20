require 'rails_helper'

RSpec.describe MultiHandicapCalculator, type: :model do
  it "tracks which players had scores added" do
    golfers = [
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer1', identifier: 1, handicap: 12),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer2', identifier: 2, handicap: 13),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer3', identifier: 3, handicap: 14),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer4', identifier: 4, handicap: 15),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer5', identifier: 5, handicap: 16)
    ]
    params = {
      golfers[0].id => { handicap: golfers[0].handicap, net_score: '34' },
      golfers[1].id => { handicap: golfers[1].handicap, net_score: '' },
      golfers[2].id => { handicap: golfers[2].handicap, net_score: '' },
      golfers[3].id => { handicap: golfers[3].handicap, net_score: '32' },
      golfers[4].id => { handicap: golfers[4].handicap, net_score: '' }
    }

    calculator = MultiHandicapCalculator.new
    changed_golfers = calculator.post_scores(Date.today.strftime('%m/%d/%Y'), params).map(&:golfer)
    expect(changed_golfers).to eq([golfers[0], golfers[3]])
  end

  it "knows which golfers had a change of handicap" do
    golfers = [
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer1', identifier: 1, handicap: 12),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer2', identifier: 2, handicap: 12),
      Golfer.create!(first_name: 'Sample', last_name: 'Golfer3', identifier: 3, handicap: 12)
    ]
    golfers[0..1].each do |golfer|
      calculator = HandicapCalculator.new(golfer)
      10.times do |i|
        calculator.post_score(36, i.days.ago)
      end
      calculator.update_handicap!
      expect(golfer.handicap).to eq(12)
    end

    # give golfer 3 a history of low scores with one good round the farthest back in his history
    golfer = golfers[2]
    calculator = HandicapCalculator.new(golfer)
    9.times do |i|
      calculator.post_score(33, i.days.ago)
    end
    calculator.post_score(40, 10.days.ago)
    calculator.update_handicap!
    expect(golfer.handicap).to eq(12)

    params = {
      golfers[0].id => { handicap: golfers[0].handicap, net_score: '40' },
      golfers[1].id => { handicap: golfers[1].handicap, net_score: '36' },
      golfers[2].id => { handicap: golfers[2].handicap, net_score: '33' },
    }

    calculator = MultiHandicapCalculator.new
    changed_golfers = calculator.post_scores_and_update_handicaps(Date.today.strftime('%m/%d/%Y'), params)
    expect(changed_golfers).to eq([[golfers[0], :down], [golfers[1], false], [golfers[2], :up]])
  end
end

