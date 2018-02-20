require 'sinatra/base'

class ScoutingProject < Sinatra::Base
    get '/' do
        erb :index
    end

    helpers do
        def partial(page, options={})
            erb page, options.merge!(:layout => false)
        end
    end
end


