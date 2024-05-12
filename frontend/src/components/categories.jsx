import React, { useState, useEffect } from 'react';
import axios from 'axios';
import {useDispatch} from "react-redux";
import { setSelectedCategory } from '../actions/categoryActions';

const Categories = () => {
    const [categories, setCategories] = useState([]);
    const dispatch = useDispatch();

    useEffect(() => {
        axios.get('http://localhost:8080/categories')
            .then(response => {
                setCategories(response.data);
            })
            .catch(error => {
                console.error('Error fetching:', error);
            });
    }, []);

    const handleCategoryClick = (category) => {
        dispatch(setSelectedCategory(category));
    };


    return (
        <div className="sidebar">
            <ul>
                {categories.map((category, index) => (
                    <li key={index}
                        onClick={() => handleCategoryClick(category)}
                        className="category-list-item">
                    {category}</li>
                ))}
            </ul>
        </div>
    );
};

export default Categories;
