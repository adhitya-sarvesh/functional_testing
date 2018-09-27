class ImportsScenariosController < ApplicationController
  before_action :authorize

  # GET /imports_scenarios
  def index
    @scenarios = Scenario.all
    render json: @scenarios
  end

  # GET /imports_scenarios/:id
  def show
    @scenario = Scenario.includes(:scenario_steps).find(params[:id])
    render partial: 'show'
  end

  # GET /imports_scenarios/:id/link
  def link
    render partial: 'link', locals: { scenario_id: params[:id] }
  end
end
