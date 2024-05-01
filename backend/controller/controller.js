const { Sequelize } = require('sequelize');
const { Product } = require('../model/models');

const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: '../../database.sqlite',
});

async function getUniqueCategories() {
  try {
    const uniqueCategories = await Product.findAll({
      attributes: [[sequelize.fn('DISTINCT', sequelize.col('category')), 'category']],
    });
    return uniqueCategories.map((row) => row.category);
  } catch (error) {
    console.error('Error retrieving unique categories:', error);
    throw error;
  }
}

module.exports = { sequelize, getUniqueCategories };
