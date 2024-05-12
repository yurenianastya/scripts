const express = require('express');
const { Product } = require('../model/models');
const { getUniqueCategories } = require('../controller/controller');

const router = express.Router();

// CRUD

router.get('/products', async (req, res) => {
  const queryVals = await Product.findAll();
  res.json(queryVals);
});

router.get('/categories', async (req, res) => {
  const queryVals = getUniqueCategories()
    .then((categories) => categories)
    .catch((error) => {
      console.error('Error:', error);
      throw error;
    });

  queryVals
    .then((categories) => {
      res.json(categories);
    })
    .catch((error) => {
      res.status(500).json({ error: 'Internal Server Error' });
      console.error('Error:', error);
    });
});

router.get('/products/:category', async (req, res) => {
  const { category } = req.params;
  console.log(req.params);
  try {
    const queryVals = await Product.findAll({
      where: {
        category,
      },
    });
    res.json(queryVals);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
