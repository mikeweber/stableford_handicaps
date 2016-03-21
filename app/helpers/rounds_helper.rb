module RoundsHelper
  def handicap_movement_since_last_round(round)
    class_name = 'placeholder'

    if round.handicap > round.golfer.handicap
      class_name = 'arrow-down green'
    elsif round.handicap < round.golfer.handicap
      class_name = 'arrow-up red'
    else
      class_name = 'arrow-right'
    end

    content_tag(:span, '', class: "glyphicon glyphicon-#{class_name}")
  end
end
