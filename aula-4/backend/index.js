const express = require('express');
const logger = require('./logger');

const app = express();
const PORT = 8080;

app.get('/', (req, res) => {
  res.send('Olá, mundo do OpenTelemetry!');
  logger.info('Olá, mundo do OpenTelemetry!');
});

app.listen(PORT, () => {
  logger.info(`Servidor rodando na porta ${PORT}`);
});