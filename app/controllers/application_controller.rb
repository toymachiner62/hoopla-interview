class ApplicationController < ActionController::Base

  # TODO: Move these to yaml config
  @@host = 'https://api.hoopla.net'
  @@client_id = 'f1c03e32-2e7c-419b-affc-77ebaae196c1'
  @@client_secret = '56d833581f41cd5d6c581acec171d8ce20a94705fb21'
  
  # Get an access token to be used to make hoopla API calls
  def get_token
    params = {:grant_type => 'client_credential', :client_id => @@client_id, :client_secret => @@client_secret}
    response = HTTP.post("#{@@host}/oauth2/token", :form => params)
    response_hash = JSON.parse(response.to_s) # TODO Is JSON.parse the old skewl way of doing what i'm now seeing r.json()??
    token = response_hash['access_token']
    return token
  end
end
