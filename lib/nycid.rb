require 'httparty'
# Use NYC.ID Web Services to manage NYC.ID Authenticated Users.
# 
# Documentation for NYC.ID Web Services can be found at: http://nyc4d.nycnet/nycid/web-services.shtml 
module NYCID
  class NYCIDWebServices
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

    # Default HTTP Verb for API
    DEFAULT_METHOD = 'GET'

    def initialize(
        service_account_username: ENV['NYC_ID_WEB_SERVICES_USERNAME'],
        service_account_password: ENV['NYC_ID_WEB_SERVICES_PASSWORD'],
        api_uri: ENV['NYC_ID_WEB_SERVICES_URL']
    )
      @service_account_username = service_account_username
      @service_account_password = service_account_password
      @api_uri = api_uri
      @acs_url = Base64.encode64(Devise.omniauth_configs[:saml].strategy[:assertion_consumer_service_url])
    end

    # Checks the users email validation status using NYC.ID Web Services
    #
    # Params:
    # * +:guid+ - Unique identifier for the user from NYC.ID
    def check_email_validation_status(guid:)
      if guid.nil?
        raise ArgumentError.new("You must provide a GUID")
      end
      params = {:guid => guid}
      response = nycid_web_services_request(
          endpoint = EMAIL_VALIDATION_STATUS_ENDPOINT,
          params = params,
          method = DEFAULT_METHOD
      )
      response["validated"]
    end

    # Validates the users email address using NYC.ID Web Services
    #
    # Params:
    # * +:email_address+ - Users email address, Required if guid is nil
    def validate_email(email_address:)
      if email_address.nil?
        raise ArgumentError.new("You must provide an email_address")
      end
      "#{@api_uri}#{EMAIL_VALIDATION_ENDPOINT}?emailAddress=#{email_address}&target=#{@acs_url}"
    end

    # Retrieves a JSON-formatted user from the NYC.ID Web Services API
    #
    # Params:
    # * +:guid+ - Users unique identifier. Required if +email+ not provided.
    # * +:email+ - Users email address. Required if +guid+ not provided.
    #
    # Returns:
    # JSON-formatted user as specified by NYC.ID (http://nyc4d.nycnet/nycid/search.shtml#json-formatted-users)

    def search_user(guid: nil, email: nil)
      if guid.nil? && email.nil?
        raise ArgumentError.new("You must provide either a GUID or Email Address")
      end
      params = {:userName => @service_account_username}
      unless guid.nil?
        params[:guid] = guid
      end
      unless email.nil?
        params[:email] = email
      end
      nycid_web_services_request(
          endpoint = USER_SEARCH_ENDPOINT,
          params = params,
          method = DEFAULT_METHOD
      )
    end



    # Query the NYC.ID Web Services API
    #
    # Params:
    # * +:endpoint+  - Services endpoint being targeted
    # * +:params+ - Query parameters for the endpoint
    # * +:method+ - HTTP Verb being used in the API call. Defaults to "GET"
    #
    # Returns:
    #
    # HTTP Response from NYC.ID Web Services API Endpoint.

    private

    def nycid_web_services_request(endpoint, params, method: DEFAULT_METHOD) #:doc:
      params[:userName] = @service_account_username
      signature = generate_nycid_signature(endpoint, params, @service_account_password, method)
      params[:signature] = signature

      url = "#{ENV['NYC_ID_WEB_SERVICES_URL']}#{endpoint}"
      HTTParty.get(url, :query => params)
    end

    # Generate a signature for a request to the NYC.ID Web Services API
    #
    # Params:
    # * +:url_path+ - URL Path being accessed (without domain). See constants for valid values
    # * +:query_string+ - Query String in a hash of (key, value) pairs
    # * +:nycid_web_services_password+ - Password used to authenticate with NYC.ID Web Services.
    # * +:method+ - HTTP Verb being used in the API call. Defaults to "GET"
    #
    # Returns:
    #
    # HMAC-SHA1 Signature for NYC.ID Web Services request.

    private

    def generate_nycid_signature(url_path, query_string, signing_key, method: DEFAULT_METHOD) #:doc:
      # endpoint must begin with a forward slash
      if url_path.first != '/'
        url_path = "/#{url_path}"
      end

      # Sort the query string by keys
      parameter_values = Hash[query_string.sort_by {|key, val| key.to_s}]

      # Signature contains only the values of the sorted query string joined with no separator
      signature_parameter_values = parameter_values.map {|key, val| "#{val}"}.join()

      value_to_sign = "#{method}#{url_path}#{signature_parameter_values}"

      return OpenSSL::HMAC.hexdigest('sha1', signing_key, value_to_sign)

    end
  end
end