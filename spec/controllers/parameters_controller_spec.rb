require 'rails_helper'

RSpec.describe ParametersController, type: :controller do

  before(:each) do
    @scenario = FactoryGirl.create(:scenario)
    @parameter = FactoryGirl.create(:parameter, scenario:@scenario )
  end

  let(:valid_session) { {associate_id: 'sm056579'} }  

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {scenario_id: @scenario.id}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: {id: @parameter.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested parameter' do
      expect {
        delete :destroy, params: {id: @parameter.to_param, scenario_id: @scenario.id}, session: valid_session
      }.to change(Parameter, :count).by(-1)
    end
  end
  end