require 'httparty'
# Use NYC.ID Web Services to manage NYC.ID Authenticated Users.
# 
# Documentation for NYC.ID Web Services can be found at: http://nyc4d.nycnet/nycid/web-services.shtml 
module NYCID
  module NYCID
    # Validate a user's email address
    EMAIL_VALIDATION_ENDPOINT = "/account/validateEmail.htm"
    # Check the validation status of the user's email address
    EMAIL_VALIDATION_STATUS_ENDPOINT = "/account/api/isEmailValidated.htm"
    # Have user accept NYC.ID Terms of Use Policy
    TOU_ENDPOINT = "/account/user/termsOfUse.htm"
    # Check if user has accepted NYC.ID Terms of Use Policy
    TOU_STATUS_ENDPOINT = "/account/api/isTermsOfUseCurrent.htm"
    # Enroll (authorize) a user to authenticate to your application
    ENROLLMENT_ENDPOINT = "/account/api/enrollment.htm"
    # Check if user has enrolled (is authorized) to access your application.
    ENROLLMENT_STATUS_ENDPOINT = "/account/api/getEnrollment.htm"
    # Search for a user by their GUID or Email Address
    USER_SEARCH_ENDPOINT = "/account/api/user.htm"
    # Search for multiple users by their guids or their "Start Date"
    USERS_SEARCH_ENDPOINT = "/account/api/getUsers.htm"


    # Checks the users email validation status using NYC.ID Web Services
    #
    # Params:
    # * +:guid+ - Unique identifier for the user from NYC.ID
    def check_email_validation_status(guid:)
      params = {:guid => guid}
      response = nycid_web_services_request(endpoint = EMAIL_VALIDATION_STATUS_ENDPOINT, params = params, method = 'GET')
      return response["validated"]
    end

    # Validates the users email address using NYC.ID Web Services
    #
    #
    # Params:
    # * +:guid+ - Unique identifier for the user from NYC.ID, Required if email_address is nil
    # * +:email_address+ - Users email address, Required if guid is nil
    def validate_email(guid, email_address)
      if guid.nil? && email_address.nil?
        raise ArgumentError.new("You must provide a guid or email_address")
      else
        if guid.nil?
          params = {:emailAddress => guid}
        elsif email_address.nil?
          params = {:guid => guid}
        end
        response = nycid_web_services_request(endpoint = EMAIL_VALIDATION_ENDPOINT, params = params, method = 'GET')
      end
    end

    # Query the NYC.ID Web Services API
    #
    # Params:
    # * +:endpoint+  - Services endpoint being targeted
    # * +:params+ - Query parameters for the endpoint
    # * +:method+ - HTTP Method to use. Defaults to GET
    #
    # Returns:
    #
    # HTTP Response from NYC.ID Web Services API Endpoint.

    private

    def nycid_web_services_request(endpoint, params, method = 'GET') #:doc:
      #### TEST CODE
      # params[:guid] = "ABCD1234"
      # params[:userName] = "xxx"
      # password = "#ktccn/[i(a=j)Pdo&4{S):9=]>6Ewm.s/}}.XX-=<kK'$F][M16TR?AJ3z*g|i^"
      #### TEST CODE

      username = ENV['NYC_ID_WEB_SERVICES_USERNAME']
      params[:userName] = username
      password = ENV['NYC_ID_WEB_SERVICES_PASSWORD']
      signature = generate_nycid_signature(method, endpoint, params, password)
      params[:signature] = signature

      #### Test Code
      # puts signature.equal?("9b249ba5013256b8f46dc9a1b678699d862a1efc2a1a8bcc3c97ad4c3edac3a2")
      #### Test Code


      url = "#{ENV['NYC_ID_WEB_SERVICES_URL']}#{endpoint}"
      if method == 'GET'
        response = HTTParty.get(url, :query => params)
      end
      response
    end

    # Generate a signature for a request to the NYC.ID Web Services API
    #
    # Params:
    # * +:method+ - HTTP Method being used in the API call
    # * +:url_path+ - URL Path being accessed (without domain). See constants for valid values
    # * +:query_string+ - Query String in a hash of (key, value) pairs
    # * +:nycid_web_services_password+ - Password used to authenticate with NYC.ID Web Services.
    #
    # Returns:
    #
    # HMAC-SHA1 Signature for NYC.ID Web Services request.

    private

    def generate_nycid_signature(method, url_path, query_string, nycid_webservices_password) #:doc:
      # endpoint must begin with a forward slash
      if url_path.first != '/'
        url_path = "/#{url_path}"
      end

      # Sort the query string by keys
      parameter_values = Hash[query_string.sort_by {|key, val| key.to_s}]

      # Signature contains only the values of the sorted query string joined with no separator
      signature_parameter_values = parameter_values.map {|key, val| "#{val}"}.join()

      value_to_sign = "#{method}#{url_path}#{signature_parameter_values}"

      return OpenSSL::HMAC.hexdigest('sha1', nycid_webservices_password, value_to_sign)

    end
  end
end