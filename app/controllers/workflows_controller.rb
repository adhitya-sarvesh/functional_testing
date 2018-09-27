class WorkflowsController < ApplicationController
  before_action :authorize
  before_action :set_workflow, only: [:show, :edit, :update, :destroy]

  def index
    @workflows = Workflow.all
  end

  def show
  end

  def new
    @workflow = Workflow.new
  end

  def edit
  end

  def create
  begin  
    @workflow = Workflow.new(name: params['workflow']['name'],created_by: session[:associate_id])
    respond_to do |format|
        if @workflow.save
          if params['workflow']['scenarios_attributes'].present?
            params['workflow']['scenarios_attributes'].values.each do |scenario_id|
              if scenario_id['_destroy'] == 'false'
                add_scenario= Scenario.find(scenario_id['id']);
                @workflow.scenarios_workflows.create(:scenario => add_scenario)
              end  
            end  
          end   
          format.html { redirect_to edit_workflow_path(@workflow), notice: 'Workflow was successfully created.' }
          format.json { render :show, status: :created, location: @workflow }
        else
           format.html { render :new }
           format.json { render json: @workflow.errors, status: :unprocessable_entity }    
        end
    end
  rescue ActiveRecord::RecordNotSaved
    respond_to do |format|
      format.html { redirect_to new_workflow_path(), notice: 'An error prevented the workflow from getting saved' }
    end  
  end 
  end

  def update
    @workflow = Workflow.find(params[:id])
    respond_to do |format|
      if @workflow.update(name: params['workflow']['name'])   
        if params['workflow']['scenarios_attributes'].present?
          params['workflow']['scenarios_attributes'].values.each do |scenario_id|
            if scenario_id['_destroy'] == 'false'
              if !@workflow.scenarios.all.where(:id=>scenario_id['id']).present?
                add_scenario = Scenario.find(scenario_id['id']);
                @workflow.scenarios_workflows.create(:scenario => add_scenario) 
              end  
            else
              if @workflow.scenarios.all.where(:id=>scenario_id['id']).present?
                delete_scenario = Scenario.find(scenario_id['id']);
                @workflow.scenarios.delete(delete_scenario);
              end
            end
          end 
        end    
          format.html { redirect_to edit_workflow_path(@workflow), notice: 'Workflow was successfully updated.' }
          format.json { render :show, status: :ok, location: @workflow }
      else
        format.html { render :edit }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @workflow.destroy
    respond_to do |format|
      format.html { redirect_to workflows_url, notice: 'Workflow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_workflow
      @workflow = Workflow.find(params[:id])
    end
    
    def workflow_params
      params.require(:workflow).permit(:name, scenarios_attributes:[:id,:_destroy])
    end
end
