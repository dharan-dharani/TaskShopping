const mongoose=require ("mongoose");

const orderSchema= new mongoose.Schema(

    {
uid:{type:String,required:true},
pid: {type:mongoose.Schema.Types.ObjectId, ref: 'Product' },
    }

)

module.exports=mongoose.model('Order',orderSchema)