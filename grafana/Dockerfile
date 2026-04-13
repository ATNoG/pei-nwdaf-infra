ARG GRAFANA_VERSION=12.4.0
FROM grafana/grafana:${GRAFANA_VERSION}

COPY provisioning/dashboards/ /etc/grafana/provisioning/dashboards/
COPY dashboards/               /var/lib/grafana/dashboards/
