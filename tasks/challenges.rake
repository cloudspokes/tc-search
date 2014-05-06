desc "Calls the API and loads all development challenges into Elasticsearch"
task :load_development do
  load_data("http://api.topcoder.com/v2/develop/challenges", "development")
end

desc "Calls the API and loads all design challenges into Elasticsearch"
task :load_design do
  load_data("http://api.topcoder.com/v2/design/challenges", "design")
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
end