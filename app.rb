require 'sinatra/base'
require 'mongo'

class ScoutingProject < Sinatra::Base
  configure do 
    client = Mongo::Client.new [ '127.0.0.1:27017' ], :database => 'unnamedScoutingProject' 
    db = client.database
    set :mongo_db, db[:unnamedScoutingProject]
  end

  get '/' do
    unless data = settings.mongo_db.find({futurematch: true}).first
      settings.mongo_db.insert_one({futurematch: true, R1: '', R2: '', R3: '', B1: '', B2: '', B3: '', MN: '', EV: ''})
      data = settings.mongo_db.find({futurematch: true}).first
    end
    @R1 = data['R1']
    @R2 = data['R2']
    @R3 = data['R3']
    @MN = data['MN']
    @EV = data['EV']
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
    3.times do |i|
      obj = JSON.parse(params["payload#{i+1}"])
      if obj == settings.mongo_db.find({matchnumber: obj[ 'matchnumber' ], teamid: obj[ 'teamid' ]}).first
        settings.mongo_db.find_one_and_update({matchnumber: obj[ 'matchnumber' ], teamid: obj[ 'teamid' ]}, obj)
      else
        settings.mongo_db.insert_one(obj)
      end
    end
  end

  get '/all' do
    settings.mongo_db.find.map{|e| e}.to_json
  end

  get '/raw' do
    hash = settings.mongo_db.find({team: {'$exists' => true}})
    hash.to_a.to_json
  end

  get '/raw/:team' do
    settings.mongo_db.find({team: params['team']}).to_a.to_json
  end

  get '/scoutmaster' do
    unless data = settings.mongo_db.find({futurematch: true}).first
      settings.mongo_db.insert_one({futurematch: true, R1: '', R2: '', R3: '', B1: '', B2: '', B3: '', MN: '', EV: ''})
      data = settings.mongo_db.find({futurematch: true}).first
    end
    @R1 = data['R1']
    @R2 = data['R2']
    @R3 = data['R3']
    @MN = data['MN']
    @EV = data['EV']
    @B1 = data['B1']
    @B2 = data['B2']
    @B3 = data['B3']
    erb :scoutmaster	
  end

  get '/future' do
    settings.mongo_db.find({futurematch: true}).first.to_json
  end

  post '/scoutmaster/submit' do
    data = {R1: params['R1'], R2: params['R2'], R3: params['R3'], B1: params['B1'], B2: params['B2'], B3: params['B3'], MN: params['MN'], EV: params['EV']}
    settings.mongo_db.find_one_and_update({futurematch: true}, {'$set' => data})
    redirect '/scoutmaster'
  end
end
