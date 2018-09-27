require 'rails_helper'

RSpec.describe ScenarioBuilder::FileGenerator do
  context '#generate!' do
    let(:scenario) { FactoryGirl.create(:scenario) }
    let(:file_generator) { ScenarioBuilder::FileGenerator.new('some_test_file', scenario) }
    let(:file) { double('file') }

    before do
      allow(File).to receive(:open).with('some_test_file', 'w+').and_yield(file)
      allow(file).to receive(:write)
      allow(file).to receive(:puts)
    end

    context 'with a valid scenario' do
      it 'sets a valid configuration' do
        expect(file).to receive(:puts).with("require '#{Rails.root}/spec/support/capybara_configuration'")
      end

      it 'sets a valid RSpec DSL' do
        expect(file).to receive(:puts).with("RSpec.describe 'Scenario test scenario', type: :request do")
      end

      it 'sets a valid test description' do
        expect(file).to receive(:puts).with("it 'tests test scenario feature' do")
      end

      it 'sets a valid driver' do
        expect(file).to receive(:puts).with("session = Capybara::Session.new(:poltergeist)")
      end

      it 'sets the driver with valid headers' do
        expect(file).to receive(:puts).with(
          "session.driver.headers = { \"User-Agent\" => \"Poltergeist\", \"Referer\" => \"https://netra.devhealtheintent.com\" }"
        )
      end

      it 'sets a default screenshot command' do
        expect(file).to receive(:puts).with("session.save_screenshot('test_scenario--1.png', full: true)")
      end
    end

    context 'with a have_content step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'have_content')
      end

      it 'sets a have_content command' do
        expect(file).to receive(:puts).with("expect(session).to have_content 'dummy value'")
      end
    end

    context 'with a dom_using_xpath step' do
      context 'when used with click' do
        before do
          FactoryGirl.create(
            :scenario_step, scenario: scenario, step_type: 'dom_using_xpath', step_value: 'xPath field|'
          )
        end

        it 'sets a dom_using_xpath with click command' do
          expect(file).to receive(:puts).with("session.find(:xpath, 'xPath field').click")
        end
      end

      context 'when used with fill_in' do
        before do
          FactoryGirl.create(
            :scenario_step, scenario: scenario, step_type: 'dom_using_xpath', step_value: 'xPath field|value'
          )
        end

        it 'sets a dom_using_xpath with fill in command' do
          expect(file).to receive(:puts).with("session.find(:xpath, 'xPath field').set('value')")
        end
      end
    end

    context 'with a has_content step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_content')
      end

      it 'sets a has_content command' do
        expect(file).to receive(:puts).with("session.has_content 'dummy value'")
      end
    end

    context 'with a has_no_content step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_no_content')
      end

      it 'sets a has_no_content command' do
        expect(file).to receive(:puts).with("session.has_no_content 'dummy value'")
      end
    end

    context 'with a has_button step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_button')
      end

      it 'sets a has_button command' do
        expect(file).to receive(:puts).with("session.has_button 'dummy value'")
      end
    end

    context 'with a has_no_button step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_no_button')
      end

      it 'sets a has_no_button command' do
        expect(file).to receive(:puts).with("session.has_no_button 'dummy value'")
      end
    end

    context 'with a has_checked_field step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_checked_field')
      end

      it 'sets a has_checked_field command' do
        expect(file).to receive(:puts).with("session.has_checked_field 'dummy value'")
      end
    end

    context 'with a has_unchecked_field step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_unchecked_field')
      end

      it 'sets a has_unchecked_field command' do
        expect(file).to receive(:puts).with("session.has_unchecked_field 'dummy value'")
      end
    end

    context 'with a has_link step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_link')
      end

      it 'sets a has_link command' do
        expect(file).to receive(:puts).with("session.has_link 'dummy value'")
      end
    end

    context 'with a has_no_link step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_no_link')
      end

      it 'sets a has_no_link command' do
        expect(file).to receive(:puts).with("session.has_no_link 'dummy value'")
      end
    end

    context 'with a has_select step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_select')
      end

      it 'sets a has_select command' do
        expect(file).to receive(:puts).with("session.has_select 'dummy value'")
      end
    end

    context 'with a has_no_select step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'has_no_select')
      end

      it 'sets a has_no_select command' do
        expect(file).to receive(:puts).with("session.has_no_select 'dummy value'")
      end
    end

    context 'with a add_delay step' do
      before do
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'add_delay', step_value: '10')
      end

      it 'sets a sleep command' do
        expect(file).to receive(:puts).with("sleep '10'.to_i")
      end
    end

    context 'with a import step' do
      before do
        import_scenario = FactoryGirl.create(:scenario, name: 'import scenario')
        FactoryGirl.create(:scenario_step, scenario_id: import_scenario.id)
        FactoryGirl.create(:scenario_step, scenario: scenario, step_type: 'import', step_value: import_scenario.id)
      end

      it 'sets the steps from the imported scenario' do
        expect(file).to receive(:puts).with("session.dummy_step 'dummy value'")
      end
    end

    # invoke the generate! method, subject for test
    after do
      file_generator.generate!
    end
  end
end
