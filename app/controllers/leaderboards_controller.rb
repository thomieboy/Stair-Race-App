class LeaderboardsController < ApplicationController
   # before_action :set_leaderboard, only: [:show, :edit, :update, :destroy]

  # GET /leaderboards
  # GET /leaderboards.json
  def index # gives full leaderboard
    @leaderboards = Leaderboard.where.not(stoptijd: nil)
    @leaderboards = @leaderboards.sort_by(&:timediff)
    # @leaderboards = Leaderboard.group(:game).count
  end

  # GET /leaderboards/1
  # GET /leaderboards/1.json
  def show # this gives the top xx for /leaderboards/xx
    @leaderboards = Leaderboard.all
    @leaderboards = @leaderboards.sort_by(&:timediff)
    @leaderboards = @leaderboards.first(params[:id].to_i)
    render :index
  end

  # GET /leaderboards/new
  def new
    @leaderboard = Leaderboard.new
  end

  # GET /leaderboards/1/edit
  def edit
  end

  # POST /leaderboards
  # POST /leaderboards.json
  def create
    @leaderboard = Leaderboard.new(leaderboard_params)
    logger.debug { leaderboard_params }
    respond_to do |format|
      if @leaderboard.save
        format.html { redirect_to @leaderboard, notice: 'Leaderboard was successfully created.' }
        format.json { render :show, status: :created, location: @leaderboard }
      else
        format.html { render :new }
        format.json { render json: @leaderboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaderboards/1
  # PATCH/PUT /leaderboards/1.json
  def update
    respond_to do |format|
      if @leaderboard.update(leaderboard_params)
        format.html { redirect_to @leaderboard, notice: 'Leaderboard was successfully updated.' }
        format.json { render :show, status: :ok, location: @leaderboard }
      else
        format.html { render :edit }
        format.json { render json: @leaderboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaderboards/1
  # DELETE /leaderboards/1.json
  def destroy
    if current_admin.nil?
      redirect_to '/login'
    else
      Leaderboard.delete_all
      #@leaderboard.destroy
      respond_to do |format|
        format.html { redirect_to leaderboards_url, notice: 'Leaderboard was successfully emptyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaderboard
      @leaderboard = Leaderboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaderboard_params
      params.require(:leaderboard).permit(:stoptijd, :starttijd, :participant_id, :game)
    end
end
