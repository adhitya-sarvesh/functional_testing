class RequestWorker
  include Sidekiq::Worker

  def perform(request_id, path)
    request = Request.find request_id
    request.progress!

    # create the request output directory
    Dir.mkdir("#{path}/#{request_id}") rescue nil

    file_generators = []
    tags = ActsAsTaggableOn::Tag.find(request.tags.split(', '))
    scenarios = Scenario.tagged_with(tags)
    scenario_ids = scenarios.map(&:id)
    scenario_ids.each do |scenario_id|
      scenario = Scenario.find(scenario_id)

      file_path = "#{path}/#{request_id}/#{scenario.name}.rb"
      file_generator = ScenarioBuilder::FileGenerator.new(
        file_path, scenario, run_id: request_id, dom_inspect: false
      )

      file_generator.generate!

      file_generators << file_generator
    end

    result = %x(rspec -fd --pattern "#{path}/#{request_id}/*.rb")
    output_path = "#{path}/#{request_id}/rspec_request-#{request_id}.html"

    screenshots = file_generators.map do |file_generator|
      file_generator.screenshot_paths
    end

    File.open(output_path, 'w+') do |file|
      file.write(requests_to_html(result, request_id))

      file.write(scenarios_to_html(screenshots, scenario_ids))
    end

    # generate pdf report
    pdf_report(output_path, path, request_id)

    # prepare and send report notification to Associate
    email = request.solution.configuration_by_key('email')
    email = request.associate.try(:email) if email.blank?
    ReportMailer.report(email, request.id).deliver_later

    request.complete!
  end

  private

    def pdf_report(html_file, path, request_id)
      content = File.read(html_file)
      kit = PDFKit.new("<div #{font_style}>#{content}</div>".html_safe)
      pdf = kit.to_pdf

      kit.to_file("#{path}/#{request_id}/request_report-#{request_id}.pdf")
    end

    def requests_to_html(result, request_id)
      passed = false
      passed = true if (result.include? '0 failures')

      if passed
        result_status = "<div class='label label-success'>All Scenarios Passing</div>"
      else
        result_status = "<div class='label label-danger'>Some Scenarios Failed</div>"
      end

      request = Request.find request_id
      request_link = "#{ENV['SITE_ADDRESS']}/requests/#{request.id}"
      description = request.try(:description).present? ? request.description : 'No Description Provided'

      "<h1 #{header_style}>Report Details</h1>" +
      "<table width='100%' border='1' cellspacing='0'>" +
        "<tr><td>Requested By</td><td>#{request.creator.try(:name)} (#{request.creator.try(:id)})</td></tr>" +
        "<tr><td>Request Link</td><td><a href='#{request_link}'>#{request_link}</a></td></tr>" +
        "<tr><td>Request Date</td><td>#{request.created_at.strftime('%d %B %Y %H:%M:%S %P')}</td></tr>" +
        "<tr><td colspan='2'><pre>#{description}</pre></td></tr>" +
      "</table>" +
      "<h1 #{header_style}>Summary</h1>" +
      "<table width='100%' border='1' cellspacing='0'>" +
        "<tr><td>Status</td><td>#{result_status}</td>" +
        "<tr><td colspan='2'><pre>#{result}</pre></td></tr>" +
      "</table>"
    end

    def scenarios_to_html(screenshots, scenario_ids)
      content = ''
      scenario_ids.each_with_index do |scenario_id, scenario_index|
        scenario = Scenario.find_by(id: scenario_id)

        content += "<h2 #{header_style}>Scenario</h2>" +
        "<table width='100%' border='1' cellspacing='0'>" +
          "<tr><td>Scenario</td><td>#{scenario.try(:name)}</td></tr>" +
          "<tr><td>Description</td><td>#{scenario.try(:description)}</td></tr>" +
        "</table>"

        screenshot_index = -1
        group = screenshots[scenario_index]
        scenario.steps.each_with_index do |step, index|
          content += "<br/><div style='color: #004C99; font-size: 15px;'>" +
            "#{index + 1}. #{step.pretty_print}" +
          "</div><br/>"

          if step.screenshot?
            screenshot_index += 1
            screenshot = group[screenshot_index]
            content += "<div><img src='#{ENV['SITE']}#{screenshot}'></img></div>"
          end
        end

        # default screenshot
        screenshot_index += 1
        screenshot = group[screenshot_index]
        content += "<div><img src='#{ENV['SITE']}#{screenshot}'></img></div>"
      end

      "<h1 #{header_style}>Screenshots</h1>#{content}"
    end

    def font_style
      'style="font-size: 11px; font-family: Arial;"'
    end

    def header_style
      'style="color: #000; background-color: #eee; padding: 5px;"'
    end
end
