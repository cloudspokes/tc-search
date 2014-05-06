require 'sinatra'
require 'json'
require 'httparty'

get '/' do
  erb :index
end

get '/load/development' do
  results = load_data("http://api.topcoder.com/v2/develop/challenges", "development")
  "Processed #{results} development challenges"
end

get '/load/design' do
  results = load_data("http://api.topcoder.com/v2/design/challenges", "design")
  "Processed #{results} design challenges"
end

get '/challenges/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/_search?q=#{params[:q]}")
  results['hits']['hits'].to_json
end 

get '/challenges/development/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/development/_search?q=#{params[:q]}")
  results['hits']['hits'].to_json
end 

get '/challenges/design/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/design/_search?q=#{params[:q]}")
  results['hits']['hits'].to_json
end 

not_found do
  halt 404, 'page not found'
end

def load_data(url, type)
  # get all open challenges from API
  challenges = HTTParty.get(url)['data']
  # post each one to elasticsearch
  challenges.each  do |c| 
    results = HTTParty.post("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/#{type}/#{c['challengeId']}", :body => c.to_json)
    p "Pushing: #{c['challengeName']}"    
    p "=== ERROR indexing #{c['challengeId']}" if results['error']
  end 
  challenges.size
end