require 'sinatra/base'
require 'mongo'

class ScoutingProject < Sinatra::Base
  configure do 
    client = Mongo::Client.new [ '127.0.0.1:27017' ], :database => 'unnamedScoutingProject' 
    db = client.database
    set :mongo_db, db[:unnamedScoutingProject]
  end

  get '/' do
    data = settings.mongo_db.find({futurematch: true}).first
    @R1 = data['R1']
    @R2 = data['R2']
    @R3 = data['R3']
    @MN = data['MN']
    @B1 = data['B1']
    @B2 = data['B2']
    @B3 = data['B3']
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

    get '/raw/:team' do
       hash = client[:data].find({teamid: params['team']}).first
       hash.to_json
    end

    get '/scoutmaster' do
	erb :scoutmaster	
    end

    post '/scoutmaster/redsubmit' do
      data = {R1: params['R1'], R2: params['R2'], R3: params['R3']}
      collection.find({futurematch: true}).update(data)
      "OK"
    end
    
    post '/scoutmaster/bluesubmit' do
      data = {B1: params['B1'], B2: params['B2'], B3: params['B3']}
      collection.find({futurematch: true}).update(data)
      "OK"
    end
end
