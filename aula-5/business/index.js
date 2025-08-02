const express = require('express');
const { Pool } = require('pg');
const logger = require('./logger');

const app = express();
const port = 8082;

const pool = new Pool({
  user: 'user',
  host: 'database', // Usamos o nome do serviço do Docker Compose
  database: 'userdb',
  password: 'password',
  port: 5432,
});

app.get('/user-details/:id', async (req, res) => {
  try {
    const { id } = req.params;
    logger.info({ userId: id }, `Fazendo uma requisição no PostgreSQL`)
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).send('Usuário não encontrado');
    }
    res.json(result.rows[0]);
  } catch (err) {
    logger.error({ error: err.message }, `Erro no servidor`);
    res.status(500).send('Erro no servidor');
  }
});

app.listen(port, () => {
  logger.info(`Serviço Business rodando na porta ${port}`);
});