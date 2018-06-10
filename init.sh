#!/bin/bash

echo Creating databases....
docker-compose exec db curl -X PUT http://127.0.0.1:5984/{_users,_replicator,_global_changes,secrets}
