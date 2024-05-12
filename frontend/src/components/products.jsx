import React, { useState, useEffect } from 'react';
import axios from 'axios';
import {useDispatch, useSelector} from 'react-redux';
import { addToCart } from '../actions/cartActions';

const Products = () => {

    const dispatch = useDispatch();
    const selectedCategory = useSelector(state => state.category.selectedCategory);
    const [products, setProducts] = useState([]);

    useEffect(() => {
        if (selectedCategory) {
            axios.get(`http://localhost:8080/products/${selectedCategory}`)
                .then(response => {
                    setProducts(response.data);
                })
                .catch(error => {
                    console.error('Error fetching:', error);
                });
        } else {
            axios.get('http://localhost:8080/products')
                .then(response => {
                    setProducts(response.data);
                })
                .catch(error => {
                    console.error('Error fetching:', error);
                });
        }
    }, [selectedCategory]);

    return (
        <div className="product-list">
            {products.map(product => (
                <div className="card" key={product.id}>
                    <div>
                        <span>
                            <h5 className="card-title">{product.name}</h5>
                        </span>
                        <p>Category: {product.category}</p>
                        <span className="card-price">
                            <h5 className="card-title">{product.price}</h5>
                        </span>
                        <span className="buy-btn">
                            <button onClick={() =>
                                dispatch(addToCart(product))}>Buy</button>
                        </span>
                    </div>
                </div>
            ))}
        </div>
    );
};

export default Products;
