const axios = require('axios')
let api_token = "";
export default class Api{
    constructor(){

    }

    static get_user_micropost(user_id, page, callback){
        axios.get('/api/users/' + user_id, {
            params: {
                page: page
            }
        }).then(function(response){
            callback( response.data.micropost );
        })
        .catch(function(error){
            console.log(error);   
        });
    }

    static get_users(page, callback){

    }

    static login(email, password, callback){
        axios.post('/api/login/', {
            email: email,
            password: password
        }).then(function(response){
            api_token = response.data.access_token;
            callback(response.data);
        })
        .catch(function(error){
            callback({message: "Invalid email/password combination"});
        });
    }
    
}
