require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario HealtheAnalytics Query Login', type: :request do

	it 'tests HealtheAnalytics Query Login feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'http://app.analytics.staginghealtheintent.com'
		session.fill_in 'principal', with: 'Abraham_Edward'

		sleep 3
		session.save_screenshot('healtheanalytics_query_login-0e30111b-b348-4ca6-b210-a9741fa66bd0-1.png', full: true)
		sleep '5'.to_i
		session.click_on 'Log in'
		sleep '30'.to_i
		expect(session).to have_content 'Queries'

		sleep 3
		session.save_screenshot('healtheanalytics_query_login-0e30111b-b348-4ca6-b210-a9741fa66bd0-2.png', full: true)

	end
end
