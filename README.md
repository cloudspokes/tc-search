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