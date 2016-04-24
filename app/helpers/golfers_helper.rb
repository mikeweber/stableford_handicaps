module GolfersHelper
  def golf_round_history_class(recent_rounds, best_rounds, round, index)
    class_names = index == 10 ? 'history_line ' : ''
    if best_rounds.include?(round)
      class_names << 'best_round'
    elsif !recent_rounds.include?(round)
      class_names << 'ancient_history'
    end

    class_names
  end
end
