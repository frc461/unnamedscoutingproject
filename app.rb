require 'sinatra/base'

class ScoutingProject < Sinatra::Base
    configure do 
      client = Mongo::Client.new{[ '127.0.0.127017' ], :database => 'unnamedScoutingProject' )
      db = client.database
      set :mongo_db, db[:unnamedScoutingProject]
    end

    get '/' do
        erb :index
    end

    helpers do
        def partial(page, options={})
            erb page, options.merge!(:layout => false)
        end
    end

    post "/form" do
      payloads = [
        JSON.parse( params['payload1'] ),
        JSON.parse( params['payload2'] ),
        JSON.parse( params['payload3'] } 
      ]
      collection = client[:data]
      collection.insert_many(payloads) 
        payloads = [
            JSON.parse( params['payload1'] ),
            JSON.parse( params['payload2'] ),
            JSON.parse( params['payload3'] ) 
        ]
        client = Mongo::Client.new([ '127.0.0.127017' ], :database => 'unnamedScoutingProject') 
                                   db = client.database
                                   collection = client[:data]
                                   collection.insert_many(payloads) 
    end

    get '/raw/:team' do
       hash = client[:data].find({teamid: params['team']}).first
       hash.to_json
    end
end
