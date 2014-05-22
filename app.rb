require 'sinatra'
require 'json'
require 'httparty'
require 'open-uri'

get '/' do
  erb :index
end

get '/challenges/search' do
  response['Access-Control-Allow-Origin'] = '*'
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/_search?q=#{URI::encode(params[:q])}")
  results['hits']['hits'].to_json
end 

get '/challenges/develop/search' do
  response['Access-Control-Allow-Origin'] = '*'
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/develop/_search?q=#{URI::encode(params[:q])}")
  results['hits']['hits'].to_json
end 

# LEGACY
get '/challenges/development/search' do
  response['Access-Control-Allow-Origin'] = '*'
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/development/_search?q=#{URI::encode(params[:q])}")
  results['hits']['hits'].to_json
end 

get '/challenges/design/search' do
  response['Access-Control-Allow-Origin'] = '*'
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/design/_search?q=#{URI::encode(params[:q])}")
  results['hits']['hits'].to_json
end 

get '/stats' do
  development = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/development/_count?q=*")
  develop = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/develop/_count?q=*")
  design = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/design/_count?q=*")
  { 
    'development' => development['count'],
    'develop' => develop['count'],
    'design' => design['count']
  }.to_json
end 

not_found do
  halt 404, 'page not found'
end