import { combineReducers } from 'redux';
import cartReducer from '../reducers/cartReducer';
import categoryReducer from "../reducers/categoryReducer";
import {configureStore} from "@reduxjs/toolkit";

const rootReducer = combineReducers({
    cart: cartReducer,
    category: categoryReducer,
});

const store = configureStore({ reducer: rootReducer });

export default store;
