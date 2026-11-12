class VibesController < ApplicationController
  before_action :set_vibe, only: %i[ show edit update destroy ]

  # GET /vibes or /vibes.json
  def index
    @vibes = Vibe.all
  end

  # GET /vibes/1 or /vibes/1.json
  def show
  end

  # GET /vibes/new
  def new
    @vibe = Vibe.new
  end

  # GET /vibes/1/edit
  def edit
  end

  # POST /vibes or /vibes.json
  def create
    @vibe = Vibe.new(vibe_params)

    respond_to do |format|
      if @vibe.save
        format.html { redirect_to @vibe, notice: "Vibe was successfully created." }
        format.json { render :show, status: :created, location: @vibe }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @vibe.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /vibes/1 or /vibes/1.json
  def update
    respond_to do |format|
      if @vibe.update(vibe_params)
        format.html { redirect_to @vibe, notice: "Vibe was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @vibe }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @vibe.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /vibes/1 or /vibes/1.json
  def destroy
    @vibe.destroy!

    respond_to do |format|
      format.html { redirect_to vibes_path, notice: "Vibe was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vibe
      @vibe = Vibe.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vibe_params
      params.expect(vibe: [ :name ])
    end
end
