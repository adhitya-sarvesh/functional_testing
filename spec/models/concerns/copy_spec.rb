require 'rails_helper'

RSpec.describe Scenario, type: :model do
  before(:each) do
    @scenario1 = FactoryGirl.create(:scenario)
    @scenario2 = FactoryGirl.create(:scenario, name: 'Copy_test scenario_0')
  end

  describe 'create copy' do
  	it 'should create a copy' do
      expect { Scenario.clone(@scenario2.id) }.
        to change { Scenario.count }.from(2).to(3)
      expect(Scenario.where(name: "Copy_#{@scenario2.name}_0")).to exist
    end
    
    it 'should create a copy with number incremented' do
      expect { Scenario.clone(@scenario1.id) }.
        to change { Scenario.count }.from(2).to(3)
      expect(Scenario.where(name: "Copy_#{@scenario1.name}_1")).to exist
    end
  end
end  
