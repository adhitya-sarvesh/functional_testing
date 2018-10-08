require 'rails_helper'

RSpec.describe ScenariosController, type: :controller do
  
  before(:each) do
    @associate = FactoryGirl.create(:associate)
    @scenario1 = FactoryGirl.create(:scenario)
    @scenario2 = FactoryGirl.create(:scenario, name: 'Copy_test scenario_0')
  end
  let(:valid_session) { { associate_id: @associate.id } }
  let(:invalid_session) { { associate_id: 'dn056581' } }

  describe 'POST #copy' do
    context 'with valid params' do
      it 'creates a new Scenario' do   
        post :copy, params: { copy_id: @scenario2.id }, session: valid_session
        expect(Scenario.where(name: "Copy_#{@scenario2.name}_0")).to exist
      end

      it 'creates a new Scenario with Copy and number incremented' do   
        post :copy, params: { copy_id: @scenario1.id }, session: valid_session
        expect(Scenario.where(name: "Copy_#{@scenario1.name}_1")).to exist
      end
    end   
    context 'with invalid params' do
      it 'does not create a new Scenario' do  
        post :copy, params: { copy_id: @scenario2.id }, session: invalid_session
        expect(response.content_type).to eq('application/json')
      end   
    end 

    context 'when error occurs' do
      before do         
        allow_any_instance_of(Scenario).to receive(:save).and_return(false)
        post :copy, params: { copy_id: @scenario2.id }, session: valid_session
      end
      
      it 'does not create a new Scenario' do   
        expect(response.content_type).to eq('application/json')
      end   
    end    
  end
  describe 'GET #mytestplan' do
    context 'no params' do
      it 'displays test plan of loggend user' do
        get :mytestplan ,session: {associate_id: @scenario1.associate.id}
        expect(controller.view_assigns["scenarios"]).to eq [@scenario1]
      end
    end
  end

  describe 'GET #othertestplan' do
    context 'no params' do
      it 'displays test plan of loggend user' do
        get :othertestplan ,session: {associate_id: @scenario1.associate.id}
        expect(controller.view_assigns["scenarios"]).not_to eq [@scenario1]
      end
    end
  end
end
