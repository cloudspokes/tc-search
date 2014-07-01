# [topcoder] Search API

Searches [topcoder] challenge data in Elasticsearch.

Rake task that run to periodically load data from tcapi into Elasticsearch.

## Elasticsearch Operations

### Create an Index

    curl -X POST /[index-name]
    
### Delete an Index

    curl -XDELETE /[index-name]

### Check if a challenge exists

    curl -i -XHEAD /challenges/development/30042552

### Delete a challenge

    curl -XDELETE '/challenges/development/30042685'

May want to switch at some point to the new APIs

https://api.topcoder.com/v2/challenges/active?type=design
https://api.topcoder.com/v2/challenges/open?type=design
https://api.topcoder.com/v2/challenges/upcoming?type=design
https://api.topcoder.com/v2/challenges/past?type=design