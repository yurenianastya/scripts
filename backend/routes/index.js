const express = require('express');
const { Product } = require('../model/models');
const { getUniqueCategories } = require('../controller/controller');
const { logger } = require('../app');

const router = express.Router();

// CRUD for products

router.get('/products', async (req, res) => {
  const queryVals = await Product.findAll();
  res.json(queryVals);
});

router.get('/categories', async (req, res) => {
  const queryVals = getUniqueCategories()
    .then((categories) => categories)
    .catch((error) => {
      logger.error('Error:', error);
      throw error;
    });

  queryVals
    .then((categories) => {
      res.json(categories);
    })
    .catch((error) => {
      res.status(500).json({ error: 'Internal Server Error' });
      logger.error('Error:', error);
    });
});

module.exports = router;
