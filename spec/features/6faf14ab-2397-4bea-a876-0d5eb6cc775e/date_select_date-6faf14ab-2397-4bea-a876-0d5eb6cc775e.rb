require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario date select date', type: :request do

	it 'tests date select date feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'https://engineering.cerner.com/terra-ui/#/components/terra-date-time-picker/date-time-picker/date-time-picker'
		session.find(:xpath, '//*[@id="site"]/div/div/div/div[2]/div/div/div[2]/div/div/div/div/div/div/div[2]/div[2]/div/div/div[1]/div/div/div/div/button').click
		session.select 'react-datepicker__month-select', from: 'April'

		sleep 3
		session.save_screenshot('date_select_date-6faf14ab-2397-4bea-a876-0d5eb6cc775e-1.png', full: true)

	end
end
