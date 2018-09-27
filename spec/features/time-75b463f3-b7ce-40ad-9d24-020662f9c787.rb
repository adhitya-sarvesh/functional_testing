require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario time', type: :request do

	it 'tests time feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'

		sleep 3
		session.save_screenshot('time-75b463f3-b7ce-40ad-9d24-020662f9c787-1.png', full: true)
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div/input[2]').set('04')

		sleep 3
		session.save_screenshot('time-75b463f3-b7ce-40ad-9d24-020662f9c787-2.png', full: true)
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[2]/div/input[3]').set('56')
		sleep 3
		session.save_screenshot('time-75b463f3-b7ce-40ad-9d24-020662f9c787-3.png', full: true)

	end
end
