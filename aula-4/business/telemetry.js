const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-http');
const { PeriodicExportingMetricReader } = require('@opentelemetry/sdk-metrics');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { TraceIdRatioBasedSampler } = require('@opentelemetry/sdk-trace-node');

//Logs
const { PinoInstrumentation } = require('@opentelemetry/instrumentation-pino');
const { OTLPLogExporter } = require('@opentelemetry/exporter-logs-otlp-http');
const { BatchLogRecordProcessor } = require('@opentelemetry/sdk-logs');

const traceExporter = new OTLPTraceExporter({
  url: 'http://otel-collector:4318/v1/traces',
});

const metricExporter = new OTLPMetricExporter({
  url: 'http://otel-collector:4318/v1/metrics',
});

const logExporter = new OTLPLogExporter({
  url: 'http://otel-collector:4318/v1/logs',
});

const logRecordProcessor = new BatchLogRecordProcessor(logExporter);

const sdk = new NodeSDK({
  traceExporter: traceExporter,
  sampler: new TraceIdRatioBasedSampler(1),

  metricReader: new PeriodicExportingMetricReader({
    exporter: metricExporter,
  }),
  logRecordProcessor,
  instrumentations: [
    getNodeAutoInstrumentations(),
    new PinoInstrumentation(),
  ],
});

sdk.start();
console.log('OpenTelemetry SDK iniciado e configurado para exportar para o Collector.');

process.on('SIGTERM', () => {
  sdk.shutdown()
    .then(() => console.log('Telemtry SDK terminado com sucesso.'))
    .catch((error) => console.log('Erro ao terminar o Telemtry SDK.', error))
    .finally(() => process.exit(0));
});
