class ParametersController < ApplicationController
  before_action :authorize
  before_action :set_parameter, only: [:edit, :update, :destroy]

  def new
    scenario = Scenario.find(params[:scenario_id])
    @parameter = scenario.parameters.new
  end

  def edit
  end

  def create
    scenario = Scenario.find(parameter_params[:scenario_id])
    @parameter = scenario.parameters.new(parameter_params[:id])
    @parameter.key = parameter_params[:key]
    @parameter.value = parameter_params[:value]
    respond_to do |format|
      if @parameter.save
        format.html { redirect_to new_scenario_parameter_path }
      else
        format.html { render :new }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @parameter.update(parameter_params)
        format.html { redirect_to new_scenario_parameter_path }
      else
        format.html { render :edit }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @parameter.destroy
    respond_to do |format|
      format.html { redirect_to new_scenario_parameter_path, notice: 'Parameter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_parameter
    @parameter = Parameter.find(params[:id])
  end

  def parameter_params
    params.require(:parameter).permit(:key, :value, :scenario_id)
  end
end

