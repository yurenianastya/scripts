export const addToCart = (product) => ({
    type: 'ADD_TO_CART',
    payload: product
});

export const removeFromCart = (index) => ({
    type: 'REMOVE_FROM_CART',
    payload: index
});
