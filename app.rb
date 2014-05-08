require 'sinatra'
require 'json'
require 'httparty'

enable cross_origin

get '/' do
  erb :index
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