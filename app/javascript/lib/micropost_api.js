const axios = require('axios')
export default class Api{
    constructor(){

    }

    static get ERR_API_TOKEN_NOT_FOUND(){ return "Token was not found. Please log in."; }

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

    static get_api_token(){
        let api_token = localStorage.getItem("api_token");
        if(api_token === null) throw Api.ERR_API_TOKEN_NOT_FOUND;
        return api_token;
    }

    static is_exist_api_token(){
        return !!localStorage.getItem("api_token");
    }

    static get_users(page, callback){
        let api_token = this.get_api_token();
        axios.defaults.headers.common['Authorization'] = api_token;
        axios.get('/api/users/', {
            params:{
                page: page
            }
        }).then(function(response){
            response.result = true;
            callback(response);
        })
        .catch(function(error){
            callback({result: false});
        });
    }

    static login(email, password, callback){
        axios.post('/api/login/', {
            email: email,
            password: password
        }).then(function(response){
            localStorage.setItem("api_token", response.data.access_token);
            callback(response.data);
        })
        .catch(function(error){
            callback({message: "Invalid email/password combination"});
        });
    }

    static get_own_feed(page, callback){
        let api_token = this.get_api_token();
        axios.defaults.headers.common['Authorization'] = api_token;
        axios.get('/api/feed/', {
            params: {
                page: page
            }
        }).then(function(response){
            response.result = true;
            callback(response);
        })
        .catch(function(error){
            callback({result: false});
        });
    }
}
