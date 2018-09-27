module ScenariosHelper
  def key_value_fields?(steps)
    return false unless steps.object

    ['fill_in', 'select', 'fill_in_dynamic' , 'fill_time' , 'fill_in_time'].include? steps.object.step_type
  end

  def disabled_fields?(steps)
    return false unless steps.object

    ['dom_inspector', 'save_screenshot'].include? steps.object.step_type
  end

  def select_date?(steps)
    return false unless steps.object

    ['select_date'].include? steps.object.step_type
  end

  def xpath_fields?(steps)
    return false unless steps.object

    ['dom_using_xpath'].include? steps.object.step_type
  end

  def add_delay_field?(steps)
    return false unless steps.object

    ['add_delay'].include? steps.object.step_type
  end

  def import_scenarios?(steps)
    return false unless steps.object

    ['import'].include? steps.object.step_type
  end

  def set_selected(steps, key)
    return nil unless steps.object

    if steps.object.step_value_with.present?
      key == 'fill_with' ? '' : nil
    else
      key == 'fill_with' ? nil : ''
    end
  end

  def member_solutions
    Associate.find_by(id: session[:associate_id]).try(:solutions)
  end

  def options_for_scenarios
    Scenario.all.collect { |scenario| [scenario.name,scenario.id] }
  end
end
