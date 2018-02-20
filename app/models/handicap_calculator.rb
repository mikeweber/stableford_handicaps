class HandicapCalculator
  attr_accessor :golfer, :round_date
  def initialize(golfer)
    @golfer     = golfer
  end

  def post_score(score, date_of_round = Date.today, handicap = golfer.handicap)
    golf_rounds.create!(handicap: handicap, net_score: score, occurred_on: date_of_round, medical_status: golfer.medical_status)

    return self
  end

  def remove_score(round_id)
    golf_rounds.delete(round_id)
    redo_handicap!
  end

  def high_round?(round)
    best_recent_rounds.include?(round)
  end

  def redo_handicap!
    return if recent_rounds.empty?
    old_handicap = golfer.handicap
    oldest_round_index = [golf_rounds.count, 20].min - 1
    most_recent_index = [oldest_round_index - 9, 0].max
    golfer.handicap = golf_rounds.ordered_by_recent[most_recent_index].handicap
    while most_recent_index >= 0
      round_window = golf_rounds.ordered_by_recent[most_recent_index..oldest_round_index]
      update_handicap(round_window)
      most_recent_index -= 1
      oldest_round_index -= 1
    end

    golfer.update(handicap: golfer.handicap)
    if old_handicap < golfer.handicap
      return :up
    elsif old_handicap > golfer.handicap
      return :down
    end
    return false
  end

  def update_handicap!(rounds = recent_rounds)
    return false unless handicap_changed = update_handicap(rounds)

    golfer.update(handicap: golfer.handicap)

    return handicap_changed
  end

  def update_handicap(rounds = recent_rounds)
    return false if rounds.length <= 2

    handicap_changed = false
    avg = average(round_gross_scores(best_recent_rounds(rounds)))
    handicap_range = [34-avg, 36.5-avg]
    if golfer.handicap > handicap_range[1]
      golfer.handicap = handicap_range[1].floor
      handicap_changed = :down
    elsif golfer.handicap <= handicap_range[0]
      golfer.handicap = handicap_range[0].floor + 1
      handicap_changed = :up
    end

    return handicap_changed
  end

  def net_average(recent_scores = recent_round_net_scores)
    average(recent_scores)
  end

  def average(recent_scores = recent_round_gross_scores)
    recent_scores.sum / recent_scores.length.to_f
  end

  def sum_of_best_rounds(rounds = best_recent_rounds)
    rounds.inject(0) do |sum, round|
      sum + round.net_score(golfer.handicap)
    end
  end

  def best_recent_scores(scores)
    sorted_scores(scores)[0..(round_limit(scores) - 1)]
  end

  def best_recent_rounds(rounds = recent_rounds)
    sorted_rounds(rounds)[0..(round_limit(rounds) - 1)]
  end

  def sorted_scores(scores = recent_round_gross_scores)
    scores.sort_by { |score| -score }
  end

  def sorted_rounds(rounds)
    rounds.sort_by { |round| -round.net_score(golfer.handicap) }
  end

  def recent_round_net_scores
    round_net_scores(best_recent_rounds(golf_rounds.recent))
  end

  def round_net_scores(rounds)
    rounds.collect { |round| round.net_score(golfer.handicap) }
  end

  def recent_round_gross_scores
    round_gross_scores(golf_rounds.recent)
  end

  def round_gross_scores(rounds)
    rounds.map(&:gross_score)
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
