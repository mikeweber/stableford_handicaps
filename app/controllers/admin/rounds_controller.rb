class Admin::RoundsController < AdminApplicationController
  def index
    @golfers = Golfer.alphabetized
  end

  def recent_updates
    @rounds, @occurred_on = Round.for_date(occurred_on)
    @recent_round_dates = Round.recent_dates
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

  private

  def occurred_on
    params[:occurred_on].presence
  end
end
