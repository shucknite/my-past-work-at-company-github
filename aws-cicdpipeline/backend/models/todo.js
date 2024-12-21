const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//create schema for toda
const TodoSchema = new Schema({
	action: {
		type: String,
		required: [true, 'The todo text field is required']
	}
});

//create model for todo
const Todo = mongoose.model('Todo', TodoSchema);

module.exports = Todo;