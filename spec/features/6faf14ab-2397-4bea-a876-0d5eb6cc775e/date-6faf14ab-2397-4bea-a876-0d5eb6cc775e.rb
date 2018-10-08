require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario date', type: :request do

	it 'tests date feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/button').click

		sleep 3
		session.save_screenshot('date-6faf14ab-2397-4bea-a876-0d5eb6cc775e-1.png', full: true)
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/input[2]').set('12/23/2014')

		sleep 3
		session.save_screenshot('date-6faf14ab-2397-4bea-a876-0d5eb6cc775e-2.png', full: true)

	end
end
