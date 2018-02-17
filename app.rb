require 'sinatra/base'

class ScoutingProject < Sinatra::Base
get '/' do
  erb :index
end
end
