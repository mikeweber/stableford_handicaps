class Admin::RoundsController < AdminApplicationController
  def index
    @golfers = Golfer.alphabetized
  end

  def create
    round_date = params[:occurred_on]
    golfer_params = params[:golfer].permit!
    @golfers = MultiHandicapCalculator.new.post_scores_and_update_handicaps(round_date, golfer_params.to_hash)

    flash[:success] = "Posted scores for #{@golfers.length} golfers."
    redirect_to rounds_path
  end

  def destroy
    round = Round.find(params[:id])
    calculator = HandicapCalculator.new(round.golfer)
    calculator.remove_score(round.id)
    redirect_to admin_golfer_path(round.golfer)
  end
end
