const jwt =require('jsonwebtoken');
const JWT_SECRET='professor';

const verifyToken =(req,res,next)=>{

    const token=req.headers['authorization']?.split(' ')[1];

    if(!token){
     return res.status(403).json({
        message:"Token is needed"
     });
    }

    jwt.verify(token,JWT_SECRET,(err,decoded)=>{

        if(err){
            return res.status(401).json({
                message:"Token is Invalid"
             }); 
        }

        req.id=decoded.id;
        next();

    });
}

module.exports=verifyToken;