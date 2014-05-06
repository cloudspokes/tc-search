desc "Calls the API and loads all development challenges into Elasticsearch"
task :load_development do
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=1000", "development")
end

desc "Calls the API and loads all design challenges into Elasticsearch"
task :load_design do
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=1000", "design")
end

def load_data(url, type)
  # get all open challenges from API
  challenges = HTTParty.get(url)['data']
  # post each one to elasticsearch
  challenges.each  do |c| 
    if c['challengeType'].to_s == 'Design First2Finish'
      c['checkpointSubmissionEndDate'] = c['submissionEndDate']
    end   
    p "Pushing: #{c['challengeName']} to /#{ENV['INDEX_CHALLENGES']}/#{type}/#{c['challengeId']}"
    results = HTTParty.post("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/#{type}/#{c['challengeId']}", :body => c.to_json) 
    if results['error']
      p "=== ERROR indexing #{c['challengeId']}"
      p results
    end
  end 
end