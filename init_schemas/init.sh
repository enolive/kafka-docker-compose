#!/bin/sh

SCHEMA_HOST=http://schema-registry:8081

until curl -s $SCHEMA_HOST
do
    echo "waiting for schema-registry to be up..."
    sleep 1
done

create_schema() {
  schema_topic=$1
  schema_file="/schemas/$2"
  schema_file_content=$(jq @json "$schema_file")
  schema_payload='{"schema":'$schema_file_content'}'

  curl -X POST --location "$SCHEMA_HOST/subjects/$schema_topic-value/versions" \
    -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    -d "$schema_payload"
}

create_schema "my-awesome-topic" "example.avsc"