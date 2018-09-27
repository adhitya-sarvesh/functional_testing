class ScenariosController < ApplicationController
  before_action :authorize
  before_action :set_scenario, only: [:show, :edit, :update, :destroy, :generate]
  
  # GET /scenarios
  def index
    if params[:tag].present?
      @scenarios = Scenario.tagged_with(params[:tag])
    else
      @scenarios = Scenario.all
    end
  end

  # GET /scenarios/new
  def new
    @scenario = Scenario.new
  end

  # GET /scenarios/1/edit
  def edit
  end

  # POST /scenarios
  def create
    # check for add in steps
     
    if params['scenario']['scenario_steps_attributes'] && params['scenario']['scenario_steps_attributes'].keys.grep(/_scenario_steps/).present?
      params['scenario']['scenario_steps_attributes'] = add_in_params_with_order(
        params['scenario']['scenario_steps_attributes']
      )
    end
    
    @scenario = Scenario.new(scenario_params)
    @scenario.created_by = session[:associate_id]

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to edit_scenario_path(@scenario), notice: 'Test Plan was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  def update
    # check for add in steps
    if params['scenario']['scenario_steps_attributes'].keys.grep(/_scenario_steps/).present?
      # clear all steps for reordering
      @scenario.steps.destroy_all

      params['scenario']['scenario_steps_attributes'] = add_in_params_with_order(
        params['scenario']['scenario_steps_attributes']
      )
    end

    respond_to do |format|
      if @scenario.update(scenario_params.merge(updated_by: session[:associate_id]))
        format.html { redirect_to edit_scenario_path(@scenario), notice: 'Test Plan was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def generate
    path = "#{Rails.root}/spec/features/#{@scenario.name}.rb"

    file_generator = ScenarioBuilder::FileGenerator.new(
      path, @scenario, run_id: SecureRandom.uuid
    )
    file_generator.generate!

    file_path = path.gsub(@scenario.name, "#{file_generator.file_name}-#{file_generator.options[:run_id]}")
    test_output = %x(bundle exec rspec "#{file_path}")
    file_content = File.read file_path rescue ''

    passed = false
    passed = true if (test_output.include? '0 failures' and test_output.include? '1 example')

    render json: {
      passed: passed,
      test: test_output,
      screenshots: file_generator.screenshot_paths,
      dom_inspects: file_generator.dom_inspects,
      content: file_content
    }
  end

  # DELETE /scenarios/1
  def destroy
    @scenario.destroy
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Test Plan was successfully destroyed.' }
    end
  end

  def copy
   @scenario = Scenario.clone(params['copy_id']) 
   if !@scenario  
    render :json => { error_message: 'Error Occurred' }, status: :unprocessable_entity
   else
    @scenario.created_by = session[:associate_id] 
    render json: { scenario_id: @scenario.id }
   end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scenario_params
      params.require(:scenario).permit(
        :tag_list, :name, :description, :solution_id, scenario_steps_attributes: [
          :step_type, :step_value, :_destroy, :id, :step_value_key, :step_value_with
        ]
      )
    end

    # recreate all steps, with newer order
    def add_in_params_with_order(add_in_params)
      new_params, index = {}, 0
      add_in_params.each do |_k, v|
        value = v.to_unsafe_hash
        value.delete(:id)

        new_params["#{index}"] = value
        index += 1
      end

      new_params
    end
end
