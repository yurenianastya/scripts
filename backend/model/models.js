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

(async () => {
  try {
    await sequelize.sync();
    console.log('Database synchronized');
  } catch (error) {
    console.error('Error synchronizing database:', error);
  }
})();

module.exports = { Product };
