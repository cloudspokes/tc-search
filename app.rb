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

not_found do
  halt 404, 'page not found'
end