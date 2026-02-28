# Rosewood Monitoring Status (Oct 2025)

This document provides an overview of the current state of monitoring at Rosewood, along with evaluation of potential implementation paths. It includes a case study of Datadog as a potential candidate solution to enhance our observability capabilities.

## 1. Data Scope

The scopes that we aim to target for comprehensive monitoring include:

- **Website Analytics**: User behavior, page performance, conversion tracking
- **Microservices Metrics and Logs**: Application performance, error rates, request traces, business logic events
- **Infrastructure**: Server metrics, container performance, network statistics, resource utilization
- **Derived Insights**: Advanced analytics and correlations focused on business value and site reliability (non-existent for now)

## 2. Observability Wishlist

- Visibility for upper management
- Forecast of errors (detecting them ahead of time)
- Continuous site performance monitoring

## 3. Current Limitations

### 3.1 Limited Visibility

While data is present across various systems, the act of making that data accessible and especially visible to higher management is very costly and time consuming. This creates a significant barrier to effective decision-making and strategic planning.

## 4. Possible Implementation Paths

There are multiple ways to achieve the required coverage we need for adequate monitoring. We will discuss the main paths which can be used below. However, it is important to note that features and collected data often differ across each monitoring provider, cloud provider or tooling. Obtaining full coverage of your infrastructure may sometimes require mixing multiple tools.

### 4.1 Self-managed

Through the use of industry standard tooling, it is possible to manage our own monitoring solution. A commonly used stack for this purpose is the following:

- **Prometheus**
  - Metrics collection
  - Aggregation
- **Grafana Loki**
  - Log collection
- **Grafana**
  - Monitoring
  - Alerting
  - Visualizing

| Pros                           | Cons                                      |
| ------------------------------ | ----------------------------------------- |
| Low cost                       | More manual maintenance required          |
| Highly configurable            | Requires computing resources              |
| Composable with multiple tools | Requires a large number of separate tools |

### 4.2 Managed SaaS

Another path towards achieving observability and monitoring of our system is to leverage paid services which provide integrations into our own components. It is worth noting that each service will have slightly different offerings and features and should be selected according to needs. Some known services:

- Splunk (Data stored outside of business)
- Datadog
- New Relic

| Pros                 | Cons                            |
| -------------------- | ------------------------------- |
| Advanced features    | Data stored outside of business |
| Low maintenance      | High cost                       |
| High quality support |                                 |
| Single source        |                                 |

### 4.3 Cloud Providers

Most cloud providers will provide some form of monitoring services, these can be an additional tool to achieve greater coverage of your infrastructure. Some examples:

- AWS CloudWatch
- Azure Monitor
- Google Cloud Monitoring

| Pros                                    | Cons                              |
| --------------------------------------- | --------------------------------- |
| Pre-integrated with your infrastructure | Does not allow multi-cloud setups |
| Low maintenance                         | Potentially high costs            |

### 4.4 Hybrid (Current)

Our current approach combines cloud provider monitoring with managed SaaS solutions to leverage the benefits of both approaches. We are currently using:

- **AWS CloudWatch**
  - Infrastructure monitoring
  - Basic application metrics
  - Log aggregation from AWS services
- **New Relic**
  - Application performance monitoring (APM)
  - Error tracking and alerting
  - User experience monitoring
  - Advanced analytics and dashboards

| Pros                                  | Cons                         |
| ------------------------------------- | ---------------------------- |
| Best of both cloud and SaaS features  | Higher complexity to manage  |
| Comprehensive coverage                | Potential cost accumulation  |
| Reduced vendor lock-in                | Multiple tools to maintain   |
| Leverages existing cloud integrations | Data silos between platforms |

## 5. Case Study: Datadog as a Candidate for Rosewood

### 5.1 Integration with Rosewood IT

Datadog offers comprehensive integrations with key components of our current technology stack:

- **Akamai Integration**: Monitor CDN performance, cache hit rates, and edge server metrics. [Learn more](https://www.datadoghq.com/blog/akamai-cdn-performance/)
- **AEM Integration**: Track Adobe Experience Manager performance, content delivery, and user interactions. [Documentation](https://docs.datadoghq.com/integrations/adobe_experience_manager/)
- **Node.js Integration**: Application performance monitoring for our Node.js services with automatic instrumentation. [Documentation](https://docs.datadoghq.com/integrations/node/)
- **Kubernetes Integration**: Container orchestration monitoring with detailed cluster, pod, and service visibility. [Documentation](https://docs.datadoghq.com/containers/kubernetes/?tab=datadogoperator)
- **Commerce Tools Integration**: E-commerce platform monitoring with business metrics and transaction tracking. [Documentation](https://docs.commercetools.com/sdk/observability/datadog)
