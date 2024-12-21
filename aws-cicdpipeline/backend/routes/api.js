const express = require('express');
const router = express.Router();
const Todo = require('../models/todo'); 


// Get all todos, exposing only the id and action field to the client
router.get('/todos', (req, res, next) => {
    Todo.find({}, 'action')
        .then(data => res.json(data))
        .catch(next); // Fixed extra parentheses
});

// Create a new todo
router.post('/todos', (req, res, next) => {
    if (req.body.action) {
        Todo.create(req.body)
            .then(data => res.json(data)) // Closing the .then() block correctly
            .catch(next); // Closing the .catch() block correctly
    } else {
        res.json({
            error: 'The input field is empty'
        });
    }
});

// Delete a todo by ID
router.delete('/todos/:id', (req, res, next) => {
    Todo.findOneAndDelete({ _id: req.params.id }) // Correcting the findOneAndDelete query syntax
        .then(data => res.json(data))
        .catch(next);
});

module.exports = router;