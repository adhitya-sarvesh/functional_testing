class Scenario < ApplicationRecord
  include CopyScenario
  has_many :scenario_steps, dependent: :destroy
  accepts_nested_attributes_for :scenario_steps, allow_destroy: true
  has_many :parameters
  
  belongs_to :associate, class_name: 'Associate', foreign_key: :created_by
  belongs_to :creator, class_name: 'Associate', foreign_key: :created_by
  belongs_to :modifier, class_name: 'Associate', foreign_key: :updated_by, required: false
  belongs_to :solution
  has_many :scenarios_workflows
  has_many :workflows, through: :scenarios_workflows

  validates :name, :description, presence: true
  validates :name, uniqueness: true
  # TODO: should have atleast one visit step

  alias :steps :scenario_steps

  acts_as_taggable

  STEPS = [
    ['Visit', 'visit'],
    ['Add Delay', 'add_delay'],
    ['Import an existing Test Plan', 'import'],

    ['Click Button', 'click_on'],
    ['Fill in', 'fill_in'],
    ['Fill Time', 'fill_in_time'],
    ['Select Date', 'select_date'],
    ['Fill in with unique value', 'fill_in_dynamic'],
    ['Find DOM using xPath', 'dom_using_xpath'],

    ['Screenshot', 'save_screenshot'],

    ['Radio Button', 'choose'],
    ['Check box', 'check'],
    ['Uncheck box', 'uncheck'],
    ['Dropdown Options', 'select'],

    ['DOM inspect', 'dom_inspector'],

    ['Expect page to have', 'have_content'],

    ['Has Content', 'has_content?'],
    ['Does Not Have Content', 'has_no_content?'],

    ['Has Button', 'has_button?'],
    ['Does Not Have Button', 'has_no_button?'],

    ['Has Checked Field', 'has_checked_field?'],
    ['Does Not Have Checked Field', 'has_unchecked_field?'],

    ['Has Link', 'has_link?'],
    ['Does Not Have Link', 'has_no_link?'],

    ['Has Select', 'has_select?'],
    ['Does Not Have Select', 'has_no_select?']
  ]

  # intercept step values, used only for override
  def scenario_steps_attributes=(attributes)
    # key value support
    attributes.each do |_step, values|
      if ['fill_in','select','fill_in_dynamic','dom_using_xpath','select_date','fill_time','fill_in_time'].include? values['step_type']
        values['step_value'] = "#{values['step_value_key']}|#{values['step_value_with']}"
      end
    end

    super
  end

  def serialized_steps
    values = steps.map do |step|
      if step.import?
        existing_scenario = Scenario.find(step.step_value)

        existing_scenario.serialized_steps
      else
        if step.fill_in?
          value = "'#{step.step_value_key}', with: '#{step.step_value_with}'"
        elsif step.select?
          value = "'#{step.step_value_key}', from: '#{step.step_value_with}'"
        else
          value = "'#{step.step_value}'"
        end

        "#{step.step_type} #{value}"
      end
    end

    values.join("\n")
  end
end
