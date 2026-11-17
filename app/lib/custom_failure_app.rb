class CustomFailureApp < Devise::FailureApp
  # This method is called by Warden automatically on failure.
  # We are overriding it to always return a JSON 401 Unauthorized response.
  def respond
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = { 
      status: '401', 
      message: i18n_message 
    }.to_json
  end
end