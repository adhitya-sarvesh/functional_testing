require '/home/adhitya/functional_testing_automation/spec/support/capybara_configuration'

RSpec.describe 'Scenario create new test plan', type: :request do

	it 'tests create new test plan feature' do

		session = Capybara::Session.new(:poltergeist)
		session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }

		session.visit 'http://10.190.225.170/'
		session.fill_in 'Enter Associate Id', with: 'AS062052'

		sleep 3
		session.save_screenshot('create_new_test_plan-a50daf83-fd07-4b95-8716-0bfca5533f53-1.png', full: true)
		session.fill_in 'Enter Password', with: 'Dravid@0000'

		sleep 3
		session.save_screenshot('create_new_test_plan-a50daf83-fd07-4b95-8716-0bfca5533f53-2.png', full: true)
		session.click_on 'Aye'
		session.click_on 'New Test Plan'
		session.fill_in 'Tags', with: 'newplan'
		session.fill_in 'Name', with: 'New test plan'

		sleep 3
		session.save_screenshot('create_new_test_plan-a50daf83-fd07-4b95-8716-0bfca5533f53-3.png', full: true)
		session.fill_in 'Description', with: 'addidnd new test plan'
		session.click_on 'Add Step'

		sleep 3
		session.save_screenshot('create_new_test_plan-a50daf83-fd07-4b95-8716-0bfca5533f53-4.png', full: true)

		sleep 3
		session.save_screenshot('create_new_test_plan-a50daf83-fd07-4b95-8716-0bfca5533f53-5.png', full: true)

	end
end
