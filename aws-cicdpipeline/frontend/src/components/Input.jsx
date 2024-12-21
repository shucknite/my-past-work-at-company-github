import React, { useState } from 'react';
import axios from 'axios';

const Input = ({ getTodos }) => {
    const [action, setAction] = useState("");

    const addTodo = () => {
        const task = { action };

        if (task.action && task.action.length > 0) {
            axios.post('/api/todos', task)
                .then(res => {
                    if (res.data) {
                        getTodos();
                        setAction(""); // Reset the input field
                    }
                })
                .catch(err => console.log(err));
        } else {
            console.log('Input field required');
        }
    };

    const handleChange = (e) => {
        setAction(e.target.value);
    };

    return (
        <div>
            <input type="text" onChange={handleChange} value={action} />
            <button onClick={addTodo}>Add Todo</button>
        </div>
    );
};

export default Input;
