require 'rails_helper'

RSpec.describe WorkflowsController, type: :controller do
  
  before(:each) do
    @scenario = FactoryGirl.create(:scenario)
    @workflow = FactoryGirl.create(:workflow)
  end
  let(:valid_session) { {associate_id:'dn056581'} }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @workflow.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: @workflow.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:attr) { { id: 1, _destroy: 'false' } }
    context 'with valid params' do
      it 'creates a new Workflow' do        
        post :create, params: { name:@workflow.name, workflow: { scenarios_attributes: attr } }, session: valid_session
        expect(Workflow.where(name: @workflow.name)).to exist
      end

      it 'redirects to edit workflow' do
        post :create, params: { id: @workflow.to_param, workflow: { name: @workflow.name, scenarios_attributes: attr } }, session: valid_session
        expect(response).to be_success
      end
    end  
    context 'with invalid params' do
      it 'does not create a new Workflow' do        
        @workflow.name = ''
        post :create, params: { name:@workflow.name, workflow: { scenarios_attributes: attr } }, session: valid_session
        expect(@workflow).to_not be_valid
        expect(response). to be_success
      end
    end  
    context 'in case of ActiveRecord error' do  
      before do         
        allow(Workflow).to receive(:new) .and_raise(ActiveRecord::RecordNotSaved.new('Validation failed: Name has already been taken'))
        post :create, params: { id: @workflow.to_param, workflow: { name: @workflow.name, scenarios_attributes: attr } }, session: valid_session
      end
    
      it 'redirects to new workflow' do
        expect(response).to redirect_to(new_workflow_path())
      end
    end  
  end

  describe 'PUT #update' do
    let(:attr) { { id: 21, _destroy: 'false' } }
    context 'with valid params' do
      it 'updates the requested workflow' do
        put :update, params: { id: @workflow.to_param, workflow: { name:'Workflow2', scenarios_attributes: attr } }, session: valid_session
        @workflow.reload
        expect(Workflow.where(name: 'Workflow2')).to exist
      end

      it 'redirects to edit workflow' do
        put :update, params: { id: @workflow.to_param, workflow: { name:'Workflow2', scenarios_attributes: attr } }, session: valid_session
        expect(response).to redirect_to(edit_workflow_path(@workflow))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested workflow' do
      expect {
        delete :destroy, params: { id: @workflow.to_param }, session: valid_session
      }.to change(Workflow, :count).by(-1)
    end

    it 'redirects to the workflows list' do
      delete :destroy, params: { id: @workflow.to_param }, session: valid_session
      expect(response).to redirect_to(workflows_url)
    end
  end
end
