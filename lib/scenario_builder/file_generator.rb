module ScenarioBuilder
  class FileGenerator
    attr_reader :path, :scenario, :options

    def initialize(path, scenario, options = {})
      @path = path
      @scenario = scenario
      @options = options
    end

    def generate!
      existing_basename = scenario.name
      file_path = path.gsub(existing_basename, "#{file_name}-#{options[:run_id]}")

      File.open(file_path, 'w+') do |f|
        f.puts header

        rspec_wrapper f
      end
    end

    def screenshot_paths
      screenshots = []

      Dir.glob("#{Rails.root}/public/images/capybara/*.png") do |screenshot|
        if screenshot.include? "#{file_name}-#{options[:run_id]}"
          screenshots << "/images#{screenshot.split('/images').last}"
        end
      end

      screenshots.sort
    end

    def dom_inspects
      inspects = []

      index = 0
      Dir.glob("#{Rails.root}/public/dom_inspects/*.html") do |dom_file|
        if dom_file.include? "#{file_name}-#{options[:run_id]}"
          index += 1
          inspects << "<span class='label label-default'>Run #{index}</span>".html_safe

          inspects << File.read(dom_file).html_safe
        end
      end

      inspects.join
    end

    def file_name
      scenario.name.downcase.split.join '_'
    end

    def add_sleep(seconds)
      "\n\t\tsleep #{seconds}\n"
    end

    private

    def dom_inspect?
      return true if options[:dom_inspect].nil?

      options[:dom_inspect]
    end

    def header
      "require '#{Rails.root}/spec/support/capybara_configuration'"
    end

    def descriptive_file_name
      scenario.name
    end

    def fetch_parameter(line)
      line.split(' ').drop(1).join(' ')
    end

    def rspec_wrapper(file)
      file.write "\n"
      file.puts "RSpec.describe 'Scenario #{descriptive_file_name}', type: :request do"

      file.write "\n"
      file.write "\t"
      file.puts "it 'tests #{descriptive_file_name} feature' do"
      file.write "\n"

      # initialize session
      file.write "\t\t"
      file.puts 'session = Capybara::Session.new(:poltergeist)'
      file.write "\t\t"
      file.puts 'session.driver.headers = { "User-Agent" => "Poltergeist", "Referer" => "https://netra.devhealtheintent.com" }'
      file.write "\n"

      dom_file_index = 0
      screenshot_file_index = 0
      
      @parameters = Parameter.where(scenario_id: scenario.id)

      scenario.serialized_steps.split("\n").each do |line|
        line.scan(/%{(\S+)}/).each do |i|
          i.last
          @parameters.each do |parameter|
            if i.last.eql? parameter.key 
              line['%{' + i.last + '}'] = parameter.value
            end 
          end
        end        

        if line.starts_with? 'dom_inspector'
          if dom_inspect?
            dom_file_index += 1
            dom_file_name = "#{file_name}-#{options[:run_id]}-#{dom_file_index}"

            file.write "\n"
            file.write "\t\t"

            file.puts "inspector = ScenarioBuilder::DomInspector.new(session, '#{dom_file_name}.html')"

            file.write "\t\t"
            file.puts 'inspector.inspect!'
            file.write "\n"
          end

          next
        elsif line.starts_with? 'have_content'

          line = "expect(session).to #{line}"
        elsif line.starts_with? 'add_delay'

          line = "sleep #{fetch_parameter(line)}.to_i"
        elsif line.starts_with? 'has_content?'

          line = "session.has_content?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'dom_using_xpath'
          new_line = fetch_parameter(line).split('|')
          action = new_line.last == "'" ? ".click" : ".set(#{new_line.last.prepend("'")})"

          line = "session.find(:xpath, #{new_line.first.concat("'")})#{action}"
        elsif line.starts_with? 'select_date' 
          new_line = fetch_parameter(line).split('|')
          action = new_line.last == "'" ? ".click" : ".set(#{new_line.last.prepend("'")})"

          line = "session.find(:xpath, #{new_line.first.concat("'")})#{action}"        
        elsif line.starts_with? 'fill_in_time' 
          new_line = fetch_parameter(line).split('|')
          action = "with: #{new_line.last.prepend("'")}"
          action1 = ":name=>"
          action2 = ", match: :first ,"
          line = "session.fill_in #{action1} #{new_line.first.concat("'")} #{action2} #{action}"

        elsif line.starts_with? 'has_no_content?'

          line = "session.has_no_content?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_button?'

          line = "session.has_button?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_no_button?'

          line = "session.has_no_button?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_checked?'

          line = "session.has_checked?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_unchecked_field?'

          line = "session.has_unchecked_field?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_link?'

          line = "session.has_link?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_no_link?'

          line = "session.has_no_link?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_select?'

          line = "session.has_select?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'has_no_select?'

          line = "session.has_no_select?(#{fetch_parameter(line)})"
        elsif line.starts_with? 'choose'

          line = "session.choose(#{fetch_parameter(line)})"
        elsif line.starts_with? 'check'

          line = "session.check(#{fetch_parameter(line)})"
        elsif line.starts_with? 'uncheck'

          line = "session.uncheck(#{fetch_parameter(line)})"
        elsif line.starts_with? 'fill_in_dynamic'
          # uses string literal, required for dynamic interpolation
          dynamic_line = line.gsub('fill_in_dynamic', 'fill_in')[0..-2] + "#{Time.now.to_i}'"
          line = "session.#{dynamic_line}"
        elsif line.starts_with? 'save_screenshot'
          screenshot_file_index += 1
          screenshot_file_name = "#{file_name}-#{options[:run_id]}-#{screenshot_file_index}"

          file.write add_sleep(3)
          line = "session.save_screenshot('#{screenshot_file_name}.png', full: true)"
        else
          line = "session.#{line}"
        end

        file.write "\t\t"
        file.puts line
      end

      # mandatory final screenshot
      screenshot_file_index += 1
      screenshot_file_name = "#{file_name}-#{options[:run_id]}-#{screenshot_file_index}"
      file.write add_sleep(3)
      file.write "\t\t"
      file.puts "session.save_screenshot('#{screenshot_file_name}.png', full: true)"

      file.write "\n"
      file.write "\t"
      file.puts 'end'
      file.puts 'end'
    end
  end
end
