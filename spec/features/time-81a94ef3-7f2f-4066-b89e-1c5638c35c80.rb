require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario time', type: :request do

	it 'tests time feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'

		sleep 3
		session.save_screenshot('time-81a94ef3-7f2f-4066-b89e-1c5638c35c80-1.png', full: true)
		session.fill_in :name=> 'terra-time-hour-input' , match: :first , with: '04'

		sleep 3
		session.save_screenshot('time-81a94ef3-7f2f-4066-b89e-1c5638c35c80-2.png', full: true)
		session.fill_in :name=> 'terra-time-minute-input' , match: :first , with: '59'

		sleep 3
		session.save_screenshot('time-81a94ef3-7f2f-4066-b89e-1c5638c35c80-3.png', full: true)

	end
end
