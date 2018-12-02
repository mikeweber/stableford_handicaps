module RoundsHelper
  def handicap_movement_since_last_round(handicap, previous_handicap)
    class_name = 'placeholder'

    if handicap && previous_handicap
      if handicap < previous_handicap
        class_name = 'arrow-down green'
      elsif handicap > previous_handicap
        class_name = 'arrow-up red'
      else
        class_name = 'arrow-right'
      end
    end

    content_tag(:span, '', class: "glyphicon glyphicon-#{class_name}")
  end
end
