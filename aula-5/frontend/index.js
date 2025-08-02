const express = require('express');
const axios = require('axios');
const logger = require('./logger');

const app = express();
const port = 8081;

app.get('/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    logger.info({ userId: id }, `Buscando dados de usuário no app Business`);
    const response = await axios.get(`http://business:8082/user-details/${id}`);
    res.json(response.data);
  } catch (error) {
    logger.error({ error: error.message }, `Não foi possível buscar os dados no app Business`);
    res.status(error.response?.status || 500).send(error.response?.data || 'Erro interno no Serviço A');
  }
});

app.listen(port, () => {
  logger.info(`Serviço Frontend rodando na porta ${port}`);
});