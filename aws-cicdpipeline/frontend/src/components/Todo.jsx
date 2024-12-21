import React, { useState, useEffect } from 'react';
import axios from 'axios';

import Input from './Input';
import ListTodo from './ListTodo';

const Todo = () => {
    const [todos, setTodos] = useState([]);

    // Fetch todos when the component mounts
    useEffect(() => {
        getTodos();
    }, []);

    const getTodos = () => {
        axios.get('/api/todos')
            .then(res => {
                if (res.data) {
                    setTodos(res.data); // Use setTodos to update the state
                }
            })
            .catch(err => console.log(err));
    };

    const deleteTodo = (id) => {
        axios.delete(`/api/todos/${id}`)
            .then(res => {
                if (res.data) {
                    getTodos(); // Refresh the list after deletion
                }
            })
            .catch(err => console.log(err));
    };

    return (
        <div>
            <h1>My Todo(s)</h1>
            <Input getTodos={getTodos} />
            <ListTodo todos={todos} deleteTodo={deleteTodo} />
        </div>
    );
};

export default Todo;
