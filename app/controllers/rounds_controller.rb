class RoundsController < ApplicationController
  def index
    @rounds, @occurred_on = Round.for_date(occurred_on)
    @recent_round_dates = Round.recent_dates
  end

  private

  def occurred_on
    params[:occurred_on].presence
  end
end
