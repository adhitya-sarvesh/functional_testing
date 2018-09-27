FactoryGirl.define do
  sequence(:id) { |n| n.to_s }
  sequence(:name) { |n| "Test name #{n}" }

  factory :parameter do
    id
    key 'test_key'
    value 'value_test'
    scenario_id factory: :scenario
  end

  factory :scenario do
    id
    name 'test scenario'
    description 'my test scenario'
    creator factory: :associate
    solution
  end

  factory :scenario_step do
    id
    step_type 'dummy_step'
    step_value 'dummy value'
    scenario
  end

  factory :associate do
    id
    name 'Test Associate'
    email 'test_associate@example.com'
  end

  factory :solution do
    id
    name
    creator factory: :associate
  end

  factory :solution_configuration do
    key 'email'
    value 'netra@example.com'
  end

  factory :workflow do
    sequence(:id)
    sequence(:name) { |n| "test_workflow_#{n}" }
    creator factory: :associate
  end
end
