module WorkflowsHelper
  def options_for_tests
    Scenario.all.collect {|scenario| [scenario.name,scenario.id] }
  end	
end
