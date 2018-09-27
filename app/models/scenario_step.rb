class ScenarioStep < ApplicationRecord
  belongs_to :scenario

  attr_accessor :step_value_key, :step_value_with

  # fill in support
  def step_value_key
    self.step_value.split('|').first if fill_in? || select? || xpath? || select_date? || fill_time?
  end

  def step_value_with
    if fill_in? || select? || xpath? || select_date? || fill_time?
      value = self.step_value.split('|')
      value.length == 1 ? '' : value.last
    end
  end

  def select_date?
    step_type == 'select_date'
  end

  def fill_in?
    ['fill_in', 'fill_in_dynamic'].include? step_type
  end

  def fill_time?
    ['fill_in', 'fill_in_time'].include? step_type
  end

  def select?
    step_type == 'select'
  end

  def xpath?
    step_type == 'dom_using_xpath'
  end

  def screenshot?
    step_type == 'save_screenshot'
  end

  def add_delay?
    step_type == 'sleep'
  end

  def import?
    step_type == 'import'
  end

  def pretty_print
    Scenario::STEPS.each do |step|
      return "#{step.first} #{step_value}" if step.last == step_type
    end
  end
end
