require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario HealtheAnalytics Administration Groups', type: :request do

	it 'tests HealtheAnalytics Administration Groups feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'http://app.analytics.staginghealtheintent.com'
		session.fill_in 'principal', with: 'Abraham_Edward'

		sleep 3
		session.save_screenshot('healtheanalytics_administration_groups-2e816cdb-5fc3-4487-87b9-63af6f980ea0-1.png', full: true)
		session.click_on 'Log in'
		expect(session).to have_content 'Projects'
		session.click_on 'Groups'
		expect(session).to have_content 'Analytics Whitelist'
		expect(session).to have_content 'Analytics Data Authors'
		expect(session).to have_content 'Analytics Content Authors'

		sleep 3
		session.save_screenshot('healtheanalytics_administration_groups-2e816cdb-5fc3-4487-87b9-63af6f980ea0-2.png', full: true)

	end
end
