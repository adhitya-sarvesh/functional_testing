class PagesController < ApplicationController
  def help
    uri = URI.parse('https://raw.github.cerner.com/POTC/acid/master/HELP.md')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.get(uri.request_uri)
    markdown = markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

    @data = markdown.render(response.body)
  end

  def login
    if session[:associate_id]
      redirect_to scenarios_path
    else
      render 'layouts/login'
    end
  end

  def destroy_session
    reset_session

    redirect_to root_path, flash: { success: 'Logged out successfully' }
  end

  def associate
    associate_id = params[:associate_id]
    password = params[:password]

    associate_logged_in = false
    if !associate_id.blank? && !password.blank?
      session[:associate_id] = associate_id.upcase

      # session with encrypted credentials, unavoidable at the moment
      session[:password] = PasswordEncryptor.encrypt(password)
      associate_logged_in = associate_service
    end

    if associate_logged_in
      set_associate

      redirect_to scenarios_path, flash: { success: 'Signed in successfully' }
    else
      redirect_to root_path, flash: { danger: 'Authentication Failure, Check your credentials and try again' }
    end
  end
end
