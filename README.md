# pei-nwdaf-infra

> Project for PEI evaluation 25/26

## Overview

Infrastructure orchestration for the PEI-NWDAF platform. Provides containerized deployment of middleware services and databases required for the 5G network analytics and ML-driven resource control system.

## Purpose

Centralized Docker Compose configuration for:
- Message streaming infrastructure (Apache Kafka)
- Time-series database (InfluxDB)
- Analytical database (ClickHouse)
- ML experiment tracking (MLflow + PostgreSQL backend)
- Object storage (MinIO - S3-compatible)

## Technologies

- **Docker Compose** - Container orchestration
- **Apache Kafka** 4.1.1 - Event streaming platform
- **InfluxDB** - Time-series metrics database
- **ClickHouse** - Columnar analytical database
- **PostgreSQL** - MLflow metadata backend
- **MinIO** - S3-compatible object storage for ML artifacts
- **MLflow** - ML experiment tracking and model registry
- **Jenkins** - CI/CD pipeline automation
- **GitHub Actions** - Workflow triggers

## Architecture

The NWDAF platform follows a microservices architecture with 7 main components:

1. **Producer** - Loads DoNext 5G dataset and sends network data
2. **Ingestion** - FastAPI service receiving network data via HTTP
3. **Processor** - Data aggregation and validation with windowing
4. **Comms** - Kafka-based inter-service communication (PyKafBridge)
5. **Storage** - Data persistence (InfluxDB & ClickHouse)
6. **ML** - Machine learning inference and training service
7. **Frontend** - AION Dashboard (React/Vite web interface)

## Kafka Topics Configured

- `network.data.ingested` - 6 partitions, 7-day retention
- `network.data.processed` - 3 partitions
- `ml.inference.request` - 3 partitions

## Quick Start

```bash
docker-compose up -d
```

## Service Ports

- **Kafka**: 9092 (broker), 9093 (controller)
- **InfluxDB**: 8086
- **ClickHouse**: 8123 (HTTP), 9000 (TCP)
- **Frontend**: 5173
- **MLflow**: 5000

## Network

All services run on external network: `nwdaf-network`

## CI/CD

- Jenkins pipeline automates Docker Compose deployment
- Triggered via GitHub Actions on pushes to main branch
- Handles container lifecycle (build, up, restart)
- Self-hosted runner required

## Environment

Configuration via `.env` file. See `.env.example` for template.

## Data Pipeline Flow

```
Producer (dataset) → Ingestion (FastAPI:8000) →
Kafka (network.data.ingested) → Processor →
Kafka (network.data.processed) →
Storage (InfluxDB & ClickHouse) →
ML Service + Frontend Dashboard
```
