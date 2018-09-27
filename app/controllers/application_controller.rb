class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from AssociateService::LDAPAuthenticationFailure do |_error|
    rescue_from_authentication_errors 'LDAP Authentication Failure, Check your credentials and try again'
  end

  rescue_from PasswordEncryptor::EncryptError do |_error|
    rescue_from_authentication_errors 'LDAP Authentication Failure, Check your credentials and try again'
  end

  rescue_from PasswordEncryptor::DecryptError do |_error|
    rescue_from_authentication_errors 'LDAP Authentication Failure, Check your credentials and try again'
  end

  rescue_from OpenSSL::Cipher::CipherError do |_error|
    rescue_from_authentication_errors 'Invalid token, Session Expired'
  end

  rescue_from ActionController::InvalidAuthenticityToken do |_error|
    rescue_from_authentication_errors 'Invalid token, Session Expired'
  end

  def authorize
    redirect_to root_path, flash: { danger: 'Authorization Failure' } unless session[:associate_id]
  end

  def associate_service
    @associate_service ||= AssociateService.new(session[:associate_id], PasswordEncryptor.decrypt(session[:password]))
  end

  private

  def rescue_from_authentication_errors(message)
    reset_session

    redirect_to root_path, flash: { danger: message }
  end

  def set_associate
    session[:associate] = associate_by_lookup
  end

  # lookup for existing associate
  def associate_by_lookup
    existing_associate = Associate.find_by_id(session[:associate_id])
    if existing_associate
      associate_data = { associate_id: existing_associate.id }
      associate_data[:email] = existing_associate.email
      associate_data[:name] = existing_associate.name

      associate_data
    else
      service_data = associate_service.associate

      Associate.create!(id: service_data[:associate_id], name: service_data[:name], email: service_data[:email])

      service_data
    end
  end
end
