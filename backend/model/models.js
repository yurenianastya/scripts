const { Model, DataTypes, Sequelize } = require('sequelize');

const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: './database.sqlite',
});

class Product extends Model {}
Product.init({
  name: DataTypes.STRING,
  price: DataTypes.FLOAT,
  category: DataTypes.STRING,
}, {
  sequelize,
  modelName: 'product',
  tableName: 'products',
});

module.exports = { Product };
