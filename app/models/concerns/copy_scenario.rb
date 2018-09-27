module CopyScenario
  extend ActiveSupport::Concern

  class_methods do
    def clone(copy_id)
      @old_scenario = Scenario.find(copy_id)
      @scenario = Scenario.new
      @scenario = @old_scenario.dup 
      check_scenario = Scenario.where("name LIKE ?", "Copy_#{@old_scenario.name}%").last

      if check_scenario.present?
        copy_number = check_scenario.name.scan( /\d+\z/ ).first.to_i 
        @scenario.name = "Copy_#{@old_scenario.name}_#{copy_number+1}"
      else
        @scenario.name = "Copy_#{@old_scenario.name}_0"
      end 

      if @scenario.save
        @scenario.scenario_steps << @old_scenario.scenario_steps.collect { |scenario_steps| scenario_steps.dup }
        @scenario.parameters << @old_scenario.parameters.collect { |parameters| parameters.dup }
        @scenario.tags = @old_scenario.tags
        @scenario
      end  
    end
  end  
end    
