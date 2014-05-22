desc "Calls the API and loads all development challenges into Elasticsearch"
task :load_develop do
  p '=== LOADING OPEN DEVELOP ==='
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=1000&listType=OPEN", "develop")
  p '=== LOADING ACTIVE DEVELOP ==='
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=1000&listType=ACTIVE", "develop")
  p '=== LOADING PAST DEVELOP ==='
  load_data("http://api.topcoder.com/v2/develop/challenges?pageSize=100&listType=PAST&sortColumn=challengeId&sortOrder=desc", "develop")
end

desc "Calls the API and loads all design challenges into Elasticsearch"
task :load_design do
  p '=== LOADING OPEN DESIGN ==='
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=1000&listType=OPEN", "design")
  p '=== LOADING ACTIVE DESIGN ==='
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=1000&listType=ACTIVE", "design")
  p '=== LOADING PAST DESIGN ==='
  load_data("http://api.topcoder.com/v2/design/challenges?pageSize=100&listType=PAST&sortColumn=challengeId&sortOrder=desc", "design")
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

    # if the status is blank then it is 'completed'
    c['currentStatus'] = 'Completed' if c['currentStatus'] == ''
    c['currentPhaseName'] = 'Completed' if c['currentPhaseName'] == ''

    # remove digitalrun points --returning as string sometimes
    c.delete('digitalRunPoints')

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