require 'sinatra'
require 'json'
require 'httparty'
require 'open-uri'

get '/' do
  erb :index
end

get '/challenges/v2/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES_V2']}/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}&sort=#{opts['sort']}")
  results['hits']['hits'].to_json
end

get '/challenges/v2/develop/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES_V2']}/develop/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}&sort=#{opts['sort']}")
  results['hits']['hits'].to_json
end

get '/challenges/v2/design/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES_V2']}/design/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}&sort=#{opts['sort']}")
  results['hits']['hits'].to_json
end

get '/challenges/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}")
  results['hits']['hits'].to_json
end

get '/challenges/develop/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/develop/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}")
  results['hits']['hits'].to_json
end

# LEGACY
get '/challenges/development/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/development/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}")
  results['hits']['hits'].to_json
end

get '/challenges/design/search' do
  results = HTTParty.get("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/design/_search?q=#{URI::encode(params[:q])}&size=#{opts['max_results']}")
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

options '/challenges/*' do
  200
end

before do
   headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
end

# supported options
def opts
  {
    'max_results' => params['maxResults'] || 25,
    'sort' => params['sort'] || '_score'
  }
end
