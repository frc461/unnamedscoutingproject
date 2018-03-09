require 'sinatra/base'
require 'mongo'

class ScoutingProject < Sinatra::Base
  configure do 
    client = Mongo::Client.new [ '127.0.0.1:27017' ], :database => 'unnamedScoutingProject' 
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
      JSON.parse( params['payload3'] ) 
    ]
    settings.mongo_db.insert_many(payloads) 
  end

<<<<<<< HEAD
    get '/raw/:team' do
       hash = client[:data].find({teamid: params['team']}).first
       hash.to_json
    end

    get '/scoutmaster' do
	erb :scoutmaster	
    end

    post '/scoutmaster/redsubmit' do
      data = {R1: params['R1'], ...
      collection.find(???).update(data)
      "OK"
    end
    
    post '/scoutmaster/bluesubmit' do
      data = {B1: params['B1'], ...
      collection.find(???).update(data)
      "OK"
    end
=======
  get '/raw' do
    content_type :json
    settings.mongo_db.find().to_a.to_json
  end

  get '/raw/:team' do
    content_type :json
    settings.mongo_db.find({team: params['team']}).to_a.to_json
  end
>>>>>>> 2a1b21fb96cae5bd857d7671e5f7945b375fa465
end
