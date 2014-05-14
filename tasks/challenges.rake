desc "Calls the API and loads all development challenges into Elasticsearch"
task :load_development do
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=1000&listType=OPEN", "development")
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=1000&listType=ACTIVE", "development")
end

desc "Calls the API and loads all design challenges into Elasticsearch"
task :load_design do
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=1000&listType=OPEN", "design")
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=1000&listType=ACTIVE", "design")
end

def load_data(url, type)
  # get all open challenges from API
  challenges = HTTParty.get(url)['data']
  # post each one to elasticsearch
  challenges.each  do |c| 
    clean_up_json(c)
    p "Pushing: #{c['challengeName']} to /#{ENV['INDEX_CHALLENGES']}/#{type}/#{c['challengeId']}"
    results = HTTParty.post("#{ENV['BONSAI_URL']}/#{ENV['INDEX_CHALLENGES']}/#{type}/#{c['challengeId']}", :body => c.to_json) 
    if results['error']
      p "=== ERROR indexing #{c['challengeId']}"
      p results
    end
  end 
end

def clean_up_json(c)

    # iterate through all "date" fields and delete keys with "" values
    dates_fields = c.keys.select { |x| x.include? 'Date' }
    dates_fields.each do |f|
      c.delete(f) if c[f] == ""
    end

    # check for technologies with a single space element
    if c['technologies'].size == 1 && c['technologies'][0] == ""
      c['technologies'] = []
    end

    # check for platforms with a single space element
    if c['platforms'].size == 1 && c['platforms'][0] == ""
      c['platforms'] = []
    end

end