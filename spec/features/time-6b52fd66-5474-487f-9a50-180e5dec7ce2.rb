require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario time', type: :request do

	it 'tests time feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/button').click

		sleep 3
		session.save_screenshot('time-6b52fd66-5474-487f-9a50-180e5dec7ce2-1.png', full: true)
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/input[2]').set('12/23/2014')

		sleep 3
		session.save_screenshot('time-6b52fd66-5474-487f-9a50-180e5dec7ce2-2.png', full: true)
		session.fill_in :name=> 'terra-time-hour-input' , match: :first , with: '07'

		sleep 3
		session.save_screenshot('time-6b52fd66-5474-487f-9a50-180e5dec7ce2-3.png', full: true)
		session.fill_in :name=> 'terra-time-minute-input' , match: :first , with: '59'

		sleep 3
		session.save_screenshot('time-6b52fd66-5474-487f-9a50-180e5dec7ce2-4.png', full: true)

	end
end
