class DutiesController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Duty
  def index
    @duties = Duty.all
  end

  def show
    @duty = Duty.find(params[:id])
  end

  def new
    @duty = Duty.new
    @duties = Duty.all
  end

  # GET /duties/1/edit
  def edit
    @duty = Duty.find(params[:id])
  end

  # POST /duties
  # POST /duties.json
  def create
    @duty = Duty.new(params[:duty])

    respond_to do |format|
      if @duty.save
        format.html { redirect_to @duty, notice: 'Duty was successfully created.' }
        format.json { render json: @duty, status: :created, location: @duty }
      else
        format.html { render action: "new" }
        format.json { render json: @duty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /duties/1
  # PUT /duties/1.json
  def update
    @duty = Duty.find(params[:id])

    respond_to do |format|
      if @duty.update_attributes(params[:duty])
        format.html { redirect_to @duty, notice: 'Duty was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @duty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /duties/1
  # DELETE /duties/1.json
  def destroy
    @duty = Duty.find(params[:id])
    @duty.destroy

    respond_to do |format|
      format.html { redirect_to duties_url }
      format.json { head :no_content }
    end
  end
end
