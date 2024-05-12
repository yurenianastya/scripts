import React from "react";
import { useSelector, useDispatch } from 'react-redux';
import { removeFromCart } from '../actions/cartActions';

const Cart = () => {
    const cartItems = useSelector(state => state.cart.cartItems);
    const dispatch = useDispatch();

    const getTotalPrice = () => {
        return cartItems.reduce((total, item) => total + item.price, 0).toFixed(2);
    };

    return (
        <div className="cart-wrap">
            <h2>Shopping Cart</h2>
            <div>
                {cartItems.map((item, index) => (
                    <div key={index} className="cart-item">
                        {item.name} - ${item.price}
                        <span className="buy-btn">
                                <button onClick={() =>
                                    dispatch(removeFromCart(index))}>Remove</button>
                            </span>
                    </div>
                ))}
            </div>
            <p className="card-price">Total Price: ${getTotalPrice()}</p>
        </div>
    )
}

export default Cart;
