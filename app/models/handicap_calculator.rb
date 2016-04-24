class HandicapCalculator
  attr_accessor :golfer, :round_date
  def initialize(golfer)
    @golfer     = golfer
  end

  def post_score(score, date_of_round = Date.today, handicap = golfer.handicap)
    golfer.rounds.create!(handicap: handicap, net_score: score, occurred_on: date_of_round)

    return self
  end

  def remove_score(round_id)
    golfer.rounds.delete(round_id)
    reset_handicap_to_most_recent_round!
  end

  def update_handicap!
    return false if golfer.rounds.count <= 2

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
    best_recent_scores_sum / best_recent_scores.length.to_f
  end

  def best_recent_scores_sum
    best_recent_scores.sum
  end

  def best_recent_scores
    best_recent_rounds.collect { |round| round.net_score(golfer.handicap) }
  end

  def best_recent_rounds
    sorted_rounds[0..round_limit]
  end

  def sorted_rounds
    recent_rounds.sort_by { |round| -round.net_score(golfer.handicap) }
  end

  def round_limit
    [(recent_rounds.count / 2.0).ceil, 5].min - 1
  end

  def reset_handicap_to_most_recent_round!
    return unless most_recent_round = recent_rounds.first
    golfer.update_attribute(:handicap, most_recent_round.handicap)
  end

  def recent_rounds
    golfer.rounds.recent
  end
end
