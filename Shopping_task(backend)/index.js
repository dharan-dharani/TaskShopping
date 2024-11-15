const express=require('express');
const cors = require('cors');




const verifyToken=require('./verifyToken');
const jwt=require('jsonwebtoken') ;

const app= express();

const JWT_SECRET='professor'
const connectDB=require('./config/db')
const user=require('./models/user');
const product=require('./models/product')
const cart=require('./models/cart')
const order=require('./models/order')
connectDB();


app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended:true}));

app.get('/',(req,res)=>{
    res.status(200).send('<h1>FHello Worlsd</h1>')
})

app.post('/register',async (req,res)=>{
   const {name,email,password}=req.body;
   console.log(email,password);
   
   try {

    const existingEmail=await user.findOne({email});
    if( existingEmail ){
      return res.status(400).json({message:'email already exists'})
    }

    const User= new user({name,email,password});
     await User.save();
    res.status(200).json(User);
   } catch (error) {
    res.status(500).json({message:'Some Error Occured'});
    console.error(error);
   }
})

   
app.post('/login',async(req,res)=>{

    const {email,password}=req.body;

    try {
        const User=await user.findOne(
            {email}
        );

        if(!User){return res.status(400).json({message:'Mail not found'});}
        if(User.password !==password ){return res.status(400).json({message:'Incorrect password'});}

        const token= jwt.sign({id:User._id,name:User.name,email:User.email},

        JWT_SECRET,{expiresIn:'1h'}
        );
res.setHeader('username',User.name);
res.setHeader('email',User.email);
res.setHeader('token',token);
console.log(token);

        res.status(200).json({message:"Login Successfull"});
        

    } catch (error) {
        res.status(500).json({message:'error occured'});
        console.log(error);
    }
})

app.post('/update', async (req, res) => {
    const { id, name, email, password } = req.body;  // ID is passed in the request body
  
    try {
      const updatedUser = await user.findByIdAndUpdate(
        id,  // Use the ID from the request body
        { name, email, password },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      res.status(200).json({
        message: 'User updated successfully',
        user: updatedUser,
      });
    } catch (error) {
      res.status(500).json({ message: 'Error updating user' });
      console.error(error);
    }
  });

  app.get('/protected',verifyToken,(req,res)=>{
    //const id= req.id;
    res.status(200).send('This is Protected Route');
  })

app.get('/product/list',async(req,res)=>
{
  const Product= await product.find();
  res.status(200).json(Product);
}
)

app.post('/cart/add',verifyToken,async(req,res)=>{
  const uid= req.id;
const  {pid}=req.body;

try{
  const cartProduct=new cart({
    uid,pid
    });
    await cartProduct.save();
    
      res.status(200).json({message:'Product added successfully'});
}
catch(error){

  res.status(500).json({message:'error occurred'});
  console.error(error);
}
})

app.post('/place/order',verifyToken,async(req,res)=>{
const uid=req.id

const  {pid}=req.body;

console.log(uid);

try{
  // const itemInCart = await cart.findOne({ uid, pid });

  // if (!itemInCart) {
  //   return res.status(400).json({ message: 'Item not found in cart' });
  // }

  const Order=new order({
    uid,pid
    });
    await Order.save();
    await cart.deleteOne({ uid, pid });
    
      res.status(200).json({message:'order placed successfully'});
}
catch(error){

  res.status(500).json({message:'error occurred'});
  console.error(error);
}
})

app.get('/order/list',verifyToken,async(req,res)=>{
  const uid= req.id;

  console.log(uid);
  
 try {
  //  const orderItems = await order.find({ uid });

  //  const pids = orderItems.map(item => item.pid);
  //  console.log(pids);

  //  const orders = await product.find({ _id: { $in: pids } });

  // console.log (orders);
  //  res.status(200).json(orders);
   
  const orderItems = await order.find({ uid }).populate('pid'); 
console.log (orderItems);
   res.status(200).json(orderItems);

 } catch (err) {
   console.error(err);
   res.status(500).json({ message: "An error occurred while fetching cart data" });
 }

})



app.get('/cart/list',verifyToken,async(req,res)=>{
  const uid= req.id;
  
 try {
  //  const cartItems = await cart.find({ uid });

  //  const pids = cartItems.map(item => item.pid);
  //  console.log(pids);

  //  const products = await product.find({ _id: { $in: pids } });

  // console.log (products);
  //  res.status(200).json(products);
   
  const cartItems = await cart.find({ uid }).populate('pid'); 
console.log (cartItems);
   res.status(200).json(cartItems);

 } catch (err) {
   console.error(err);
   res.status(500).json({ message: "An error occurred while fetching cart data" });
 }

})

app.get('/product/list',async(req,res)=>{
try {
  const Products=await product.find();

  res.status(200).json(Products);
} catch (error) {
  console.error(error);
}

})


const port=5000;

app.listen(port,'0.0.0.0',()=>{
    console.log(`Server is running on ${port}`)
})


