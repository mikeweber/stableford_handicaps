class MultiHandicapCalculator
  def post_scores_and_update_handicaps(round_date, scores)
    update_handicaps!(post_scores(round_date, scores))
  end

  def post_scores(round_date, scores)
    round_date = Date.strptime(round_date, "%m/%d/%Y")
    @updated_golfers = scores.collect do |golfer_id, score|
      next unless score[:net_score].present?

      calculator = HandicapCalculator.new(Golfer.find(golfer_id)).post_score(score[:net_score], round_date, score[:handicap])
    end.compact
  end

  def update_handicaps!(calculators)
    calculators.map do |calculator|
      [calculator.golfer, calculator.update_handicap!]
    end
  end
end
