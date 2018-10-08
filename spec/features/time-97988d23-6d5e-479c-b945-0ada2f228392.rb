require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario time', type: :request do

	it 'tests time feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'

		sleep 3
		session.save_screenshot('time-97988d23-6d5e-479c-b945-0ada2f228392-1.png', full: true)
		session.fill_in :name=> 'terra-time-hour-input' , match: :first , with: '06'

		sleep 3
		session.save_screenshot('time-97988d23-6d5e-479c-b945-0ada2f228392-2.png', full: true)
		session.fill_in :name=> 'terra-time-minute-input' , match: :first , with: '59'

		sleep 3
		session.save_screenshot('time-97988d23-6d5e-479c-b945-0ada2f228392-3.png', full: true)

	end
end
