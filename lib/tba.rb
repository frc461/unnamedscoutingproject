require 'yaml'
require 'httparty'
require 'json'
require 'yaml'

class TheBlueAlliance
  raw_config = File.read('./config.yml')
  CONFIG = YAML.load(raw_config)
  include HTTParty
  base_uri 'https://www.thebluealliance.com/api/v3'

  def initialize
    @options = {headers: {'X-TBA-App-Id': 'frc461:usp:v0', 'X-TBA-Auth-Key': CONFIG['tba_api_key']}}
    @cacheCalls = {}
  end

  def call endpoint, options={}
    if @cacheCalls.has_key? endpoint
      options.merge!({'If-Modified-Since': @cacheCalls[endpoint]['lastmodified']})
    else
      @cacheCalls[endpoint] ||= {}
    end

    puts @options.merge(options)

    response = self.class.get(endpoint, @options.merge(options))
    puts response.code
    puts response.headers
    case response.code
    when 304
      @cacheCalls[endpoint]['body']
    when 200
      @cacheCalls[endpoint]['lastmodified'] = response.headers['last-modified']
      @cacheCalls[endpoint]['body'] = JSON.parse(response.body)
    end
  end

  def events options={}
    call '/events/2018', options
  end
  
  def getevent key
    endpoint = '/event/' + key
    call endpoint 
  end

  def getmatches key
    endpoint = '/event/' + key + '/matches'
    predata = call endpoint 
    predata.map{|d| {'red' => d['alliances']['red']['team_keys'].map{|t| t[3,4].to_i}, 'blue' => d['alliances']['blue']['team_keys'].map{|t| t[3,4].to_i}, 'event' => key, 'match' => d['match_number'], 'comp_level' => d['comp_level']}}
  end
end
