const mongoose= require('mongoose');

const uri = 'mongodb+srv://amjathsheik251:Football%40786@study.ovt14.mongodb.net/muthurajprofessor'
const connectDB= async() =>{
  try {
    mongoose.connect(uri);
    console.log('mongodb is connected');
    
  } catch (error) {
    console.error(error)
  }
}

module.exports= connectDB