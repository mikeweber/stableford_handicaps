class Admin::RoundsController < AdminApplicationController
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
    redirect_to recent_updates_admin_rounds_path
  end

  def destroy
    Round.find(params[:id]).destroy
    redirect_to admin_rounds_path
  end
end
