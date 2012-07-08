class RobotsController < ApplicationController
  # GET /robots
  # GET /robots.json
  def index
    @robots = scope

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @robots }
    end
  end

  # GET /robots/1
  # GET /robots/1.json
  def show
    @robot = scope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @robot }
    end
  end

  def test
    @robot = scope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /robots/new
  # GET /robots/new.json
  def new
    @robot = scope.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @robot }
    end
  end

  # GET /robots/1/edit
  def edit
    @robot = scope.find(params[:id])
  end

  # POST /robots
  # POST /robots.json
  def create
    @robot = scope.new(params[:robot])

    respond_to do |format|
      if @robot.save
        format.html { redirect_to @robot, notice: 'Robot was successfully created.' }
        format.json { render json: @robot, status: :created, location: @robot }
      else
        format.html { render action: "new" }
        format.json { render json: @robot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /robots/1
  # PUT /robots/1.json
  def update
    @robot = scope.find(params[:id])

    respond_to do |format|
      if @robot.update_attributes(params[:robot])
        format.html { redirect_to edit_robot_path(@robot), notice: 'Robot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @robot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /robots/1
  # DELETE /robots/1.json
  def destroy
    @robot = scope.find(params[:id])
    @robot.destroy

    respond_to do |format|
      format.html { redirect_to robots_url }
      format.json { head :no_content }
    end
  end

  private

  def scope
    current_user.robots
  end
end