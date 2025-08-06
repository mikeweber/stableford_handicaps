class MultiHandicapCalculator
  def post_scores_and_update_handicaps(round_date, scores)
    update_handicaps!(post_scores(round_date, scores))
  end

  def post_scores(round_date, scores)
    round_date = Date.strptime(round_date, "%m/%d/%Y")

    actual_scores = scores.reject { |_, score| score[:net_score].blank? }
    golfers = Golfer.where(id: actual_scores.keys).index_by(&:id)

    actual_scores.filter_map do |golfer_id, score|
      golfer = golfers[golfer_id]

      HandicapCalculator.new(golfer).post_score(
        score[:net_score],
        round_date,
        score[:handicap],
        score[:medical_status],
      )
    end
  end

  def update_handicaps!(calculators)
    calculators.map do |calculator|
      [calculator.golfer, calculator.update_handicap!]
    end
  end
end
