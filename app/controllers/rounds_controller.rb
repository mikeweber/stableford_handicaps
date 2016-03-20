class RoundsController < ApplicationController
  def index
    @golfers = Golfer.alphabetized
  end

  def create
    round_date = params[:occurred_on]
    updated_golfers = []
    @golfers = MultiHandicapCalculator.new.post_scores_and_update_handicaps(round_date, params[:golfer])

    flash[:success] = 
    render :results
  end

  def destroy
    Round.find(params[:id]).destroy
    redirect_to rounds_path
  end
end
