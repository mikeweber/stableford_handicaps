class GolfersController < ApplicationController
  def index
    @golfers = Golfer.alphabetized
  end

  def show
    @golfer = Golfer.find(params[:id])
    @calculator = HandicapCalculator.new(@golfer)

    render 'admin/golfers/show'
  end
end
