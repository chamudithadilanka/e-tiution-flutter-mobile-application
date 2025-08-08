import { connect } from "mongoose";


const dbconnect = connect(process.env.MONGO_URL);

export default dbconnect;