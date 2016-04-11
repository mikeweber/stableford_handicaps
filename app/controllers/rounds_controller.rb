class RoundsController < ApplicationController
  def index
    @golfers = Golfer.alphabetized
  end

  def recent_updates
    r = Round.arel_table
    @rounds = Round.where(r[:occurred_on].eq(r.project(r[:occurred_on].maximum))).includes(:golfer)
  end

  def create
    round_date = params[:occurred_on]
    updated_golfers = []
    @golfers = MultiHandicapCalculator.new.post_scores_and_update_handicaps(round_date, params[:golfer])

    flash[:success] = "Posted scores for #{@golfers.length} golfers."
    redirect_to recent_updates_rounds_path
  end

  def destroy
    round = Round.find(params[:id])
    round.destroy
    redirect_to golfer_path(round.golfer)
  end
end
