mongoose = require 'mongoose'
userSchema = require '../schemas/user'

User = mongoose.model 'User', userSchema

global.User = User
