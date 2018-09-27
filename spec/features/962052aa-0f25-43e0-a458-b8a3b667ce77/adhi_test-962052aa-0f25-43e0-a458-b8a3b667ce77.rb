require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario adhi test', type: :request do

	it 'tests adhi test feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://www.google.com/'

		sleep 3
		session.save_screenshot('adhi_test-962052aa-0f25-43e0-a458-b8a3b667ce77-1.png', full: true)

		sleep 3
		session.save_screenshot('adhi_test-962052aa-0f25-43e0-a458-b8a3b667ce77-2.png', full: true)

	end
end
