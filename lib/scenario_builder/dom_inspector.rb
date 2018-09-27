require 'open-uri'
require 'openssl'
require 'rails/all'

module ScenarioBuilder
  class DomInspector
    attr_reader :session, :path

    def initialize(session, path)
      @session = session
      @path = "#{File.expand_path('../../../', __FILE__)}/public/dom_inspects/#{path}"
    end

    def inspect!
      File.open(path, 'w+') do |f|
        f.puts '<h4>Input Fields</h4>'
        f.puts '<table class="table table-condensed table-bordered table-striped">'
        f.puts '<thead><th>name</th><th>id</th></thead>'
        if input_fields.empty?
          f.puts '<tr><td colspan="2">None found</td></tr>'
          f.puts '</table>'
        else
          f.puts input_fields
          f.puts '</tr></table>'
        end
        f.puts '</hr>'

        f.write "\n"
        f.puts '<h4>Buttons</h4>'
        f.puts '<table class="table table-condensed table-bordered table-striped">'
        f.puts '<thead><th>text</th><th>id</th></thead>'
        if buttons.empty?
          f.puts '<tr><td colspan="2">None found</td></tr>'
          f.puts '</table>'
        else
          f.puts buttons
          f.puts '</tr></table>'
        end
        f.puts '</hr>'

        f.write "\n"
        f.puts '<h4>Links</h4>'
        f.puts '<table class="table table-condensed table-bordered table-striped">'
        f.puts '<thead><th>text</th><th>id</th><th>class</th></thead>'
        if links.empty?
          f.puts '<tr><td colspan="3">None found</td></tr>'
          f.puts '</table>'
        else
          f.puts links
          f.puts '</tr></table>'
        end
      end
    end

    private

    def input_fields
      session.all('input').map do |e|
        next if e[:name].empty?

        '<tr>' + "<td>#{e[:name]}</td>" + "<td>#{e[:id]}</td>"
      end.compact.join('</tr>')
    end

    def buttons
      session.all('button').map do |e|
        next if e.text.empty?

        '<tr>' + "<td>#{e.text}</td>" + "<td>#{e[:id]}</td>"
      end.compact.join('</tr>')
    end

    def links
      session.all('a').map do |e|
        next if e.text.empty?

        '<tr>' + "<td>#{e.text}</td>" + "<td>#{e[:id]}</td>" + "<td>#{e[:class]}</td>"
      end.compact.join('</tr>')
    end
  end
end
