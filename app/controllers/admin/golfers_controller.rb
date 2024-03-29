class Admin::GolfersController < AdminApplicationController

  def index
    @golfers = Golfer.alphabetized
  end

  def new
    @golfer = Golfer.new(identifier: 0)
    render :form
  end

  def show
    @golfer = Golfer.find(params[:id])
    @calculator = HandicapCalculator.new(@golfer)
  end

  def create
    @golfer = Golfer.new(golfer_params)
    if @golfer.save
      flash[:success] = "#{@golfer.full_name_with_member_id} created"
      redirect_to admin_golfers_path
    else
      render :form
    end
  end

  def edit
    @golfer = Golfer.find(params[:id])
    render :form
  end

  def update
    @golfer = Golfer.find(params[:id])
    @golfer.attributes = golfer_params
    if @golfer.save
      flash[:success] = "#{@golfer.full_name_with_member_id} updated"
      redirect_to admin_golfers_path
    else
      render :form
    end
  end

  def destroy
    golfer = Golfer.find(params[:id])
    golfer.destroy
    flash[:success] = "#{golfer.full_name} has been removed"
    redirect_to admin_golfers_path
  end

  private

  def golfer_params
    params.require(:golfer).permit(:first_name, :last_name, :identifier, :bypass_limit, :handicap)
  end
end
