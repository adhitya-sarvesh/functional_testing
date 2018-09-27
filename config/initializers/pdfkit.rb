# Documentation reference - http://madalgo.au.dk/~jakobt/wkhtmltoxdoc/wkhtmltopdf-0.9.9-doc.html
PDFKit.configure do |config|
  config.default_options = {
    encoding: 'UTF-8',
    page_size: 'Letter',
    margin_top: '1.25in',
    margin_bottom: '0.8in',
    margin_left: '0.5in',
    margin_right: '0.5in',
    header_left: 'Cerner',
    header_right: "Netra - Test Report",
    header_line: true,
    header_spacing: 5,
    footer_line: true,
    footer_spacing: 3,
    footer_left: "#{ Time.now.strftime('%d %b %Y') }",
    footer_right: "Page [page] / [toPage]"
  }
end
