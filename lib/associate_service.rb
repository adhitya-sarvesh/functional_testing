##
# Associate Service
# LDAP Service for getting associate information
# requires "Associate ID" and credentials for LDAP service authentication
# raises LDAPAuthenticationFailure otherwise

class AssociateService
  attr_reader :associate_id, :password, :ldap, :associate_name

  def initialize(associate_id, password)
    @associate_id = associate_id
    @password = password
    @ldap = Net::LDAP.new

    # attempt to connect to Cerner LDAP service
    connect_to_ldap?
  end

  # Associate data - a Hash with associate details
  def associate
    associate_data = {}
    associate_data[:associate_id] = associate_id.upcase

   ldap.search(base: ENV['BASE'], filter: filter_by_employee_id,
                return_result: true) do |entry|
      entry.each do |attribute, values|
        case attribute
        when :cn
          associate_data[:name] = values.last
        when :mail
          associate_data[:email] = values.last
        end
      end
    end

    associate_data
  end

  class LDAPAuthenticationFailure < StandardError; end

  private


  # LDAP Service call
  # private method
  # returns true for successful authenticaion
  # raises "LDAP Authentication failure" error in case of authentication failure
  def connect_to_ldap?
    ldap.host = ENV['SERVER']
    ldap.port = ENV['LDAP_PORT']
    ldap.auth "#{associate_id}@#{ENV['DOMAIN']}", password
    fail LDAPAuthenticationFailure unless ldap.bind

    true
  end

  # setup the LDAP search filters by employeeId
  def filter_by_employee_id
    employee_id = associate_id[2..-1]
    Net::LDAP::Filter.eq('objectClass', 'person') &
      Net::LDAP::Filter.eq('objectClass', 'user') &
      Net::LDAP::Filter.eq('employeeId', employee_id)
  end
end
