export const setSelectedCategory = (category) => ({
    type: 'SET_SELECTED_CATEGORY',
    payload: category,
});

// reducers/categoryReducer.js
const initialState = {
    selectedCategory: null,
};

const categoryReducer = (state = initialState, action) => {
    switch (action.type) {
        case 'SET_SELECTED_CATEGORY':
            return {
                ...state,
                selectedCategory: action.payload,
            };
        default:
            return state;
    }
};

export default categoryReducer;
