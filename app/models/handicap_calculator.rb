class HandicapCalculator
  attr_accessor :golfer, :round_date
  def initialize(golfer)
    @golfer     = golfer
  end

  def post_score(score, date_of_round = Date.today, handicap = golfer.handicap)
    golf_rounds.create!(handicap: handicap, net_score: score, occurred_on: date_of_round)

    return self
  end

  def remove_score(round_id)
    golf_rounds.delete(round_id)
    redo_handicap!
  end

  def redo_handicap!
    old_handicap = golfer.handicap
    golfer.handicap = recent_rounds.last.handicap
    recent_rounds.length.times do |i|
      update_handicap(recent_rounds[(recent_rounds.length - i - 1)..-1])
    end

    golfer.update(handicap: golfer.handicap)
    if old_handicap < golfer.handicap
      return :up
    elsif old_handicap > golfer.handicap
      return :down
    end
    return false
  end

  def update_handicap!(rounds = golf_rounds)
    return false unless handicap_changed = update_handicap(rounds)

    golfer.update(handicap: golfer.handicap)

    return handicap_changed
  end

  def update_handicap(rounds = recent_rounds)
    return false if rounds.length <= 2

    handicap_changed = false
    while net_average(round_scores(rounds)) <= 34
      golfer.handicap += 1
      handicap_changed = :up
    end
    while net_average(round_scores(rounds)) >= 36.5
      golfer.handicap -= 1
      handicap_changed = :down
    end

    return handicap_changed
  end

  def net_average(recent_scores = recent_round_net_scores)
    best_scores = best_recent_scores(recent_scores)
    best_scores.sum / best_scores.length.to_f
  end

  def best_recent_scores(scores)
    sorted_scores(scores)[0..(round_limit(scores) - 1)]
  end

  def sorted_scores(scores = recent_round_net_scores)
    scores.sort_by { |score| -score }
  end

  def recent_round_net_scores
    round_scores(golf_rounds.recent)
  end

  def round_scores(rounds)
    rounds.collect { |round| round.net_score(golfer.handicap) }
  end

  def round_limit(scores = recent_rounds)
    [(scores.length / 2.0).ceil, 5].min
  end

  def recent_rounds
    golf_rounds.recent
  end

  def golf_rounds
    golfer.rounds
  end
end
