# frozen_string_literal: true

# OVERRIDE: This overrides http_request on FullText and fixes bug for ssl.
#
# Base file: https://github.com/samvera/hydra-derivatives/blob/v3.5.0/lib/hydra/derivatives/processors/full_text.rb
Hydra::Derivatives::Processors::FullText.class_eval do
  def http_request
    Net::HTTP.start(uri.host, uri.port, use_ssl: check_for_ssl) do |http|
      req = Net::HTTP::Post.new(uri.request_uri, request_headers)
      req.basic_auth uri.user, uri.password unless uri.password.nil?
      req.body = file_content
      http.request req
    end
  end
end