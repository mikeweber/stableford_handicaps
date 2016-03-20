class HandicapCalculator
  attr_accessor :golfer, :round_date
  def initialize(golfer)
    @golfer     = golfer
  end

  def post_score(score, date_of_round = Date.today, handicap = golfer.handicap)
    golfer.rounds.create!(handicap: handicap, net_score: score, occurred_on: date_of_round)
    return self
  end

  def update_handicap!
    handicap_changed = false
    while net_average <= 34
      golfer.update_attribute(:handicap, golfer.handicap + 1)
      handicap_changed = :up
    end
    while net_average >= 36.5
      golfer.update_attribute(:handicap, golfer.handicap - 1)
      handicap_changed = :down
    end

    return handicap_changed
  end

  def net_average
    recent_rounds = golfer.rounds.recent.collect { |round| round.net_score(golfer.handicap) }
    best_scores = recent_rounds.sort_by { |score| -score }[0..4]
    best_scores.sum / best_scores.length.to_f
  end
end
