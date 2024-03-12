#!/bin/bash

DATABASE_URL=http://172.26.129.49:5984

curl -u couchdb:couchdb -X PUT $DATABASE_URL/crime
curl -u couchdb:couchdb -d @crime_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/crime/_bulk_docs

curl -u couchdb:couchdb -X PUT $DATABASE_URL/domestic_violence
curl -u couchdb:couchdb -d @domesticVi_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/domestic_violence/_bulk_docs

curl -u couchdb:couchdb -X PUT $DATABASE_URL/park
curl -u couchdb:couchdb -d @park_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/park/_bulk_docs

curl -u couchdb:couchdb -X PUT $DATABASE_URL/population
curl -u couchdb:couchdb -d @population_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/population/_bulk_docs

curl -u couchdb:couchdb -X PUT $DATABASE_URL/salary
curl -u couchdb:couchdb -d @salary_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/salary/_bulk_docs

curl -u couchdb:couchdb -X PUT $DATABASE_URL/transportation
curl -u couchdb:couchdb -d @transportation_geojson.geojson -H "Content-Type: application/json" -X POST $DATABASE_URL/transportation/_bulk_docs