import React from 'react';
import { Provider } from 'react-redux';
import store from './stores/store';
import './App.css';
import Categories from './components/categories';
import Products from "./components/products";
import Cart from "./components/cart";

function App() {
  return (
      <div className="font-bold">
          <Provider store={store}>
              <h1 className="logo">Shop</h1>
              <div className="flex">
                  <Categories/>
                  <Products/>
                  <Cart/>
              </div>
          </Provider>
      </div>
  );
}

export default App;
