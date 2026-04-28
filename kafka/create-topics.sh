#!/bin/bash
set -e

BOOTSTRAP="${KAFKA_BOOTSTRAP_SERVER:-kafka:9092}"

echo "Waiting for Kafka broker at $BOOTSTRAP..."
until kafka-topics --bootstrap-server "$BOOTSTRAP" --list >/dev/null 2>&1; do
  echo "  still waiting..."
  sleep 3
done

echo "Creating topics..."
while IFS=' ' read -r topic retention_ms; do
  [ -z "$topic" ] && continue
  echo "  $topic (retention.ms=${retention_ms})"
  kafka-topics --bootstrap-server "$BOOTSTRAP" \
    --create --if-not-exists \
    --topic "$topic" \
    --partitions 3 \
    --replication-factor 1 \
    --config retention.ms="${retention_ms}"
done < /topics.txt

echo "Done!"
