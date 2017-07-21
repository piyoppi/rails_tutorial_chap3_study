const axios = require('axios')
export default class Api{
    constructor(){

    }

    static get ERR_API_TOKEN_NOT_FOUND(){ return "Token was not found. Please log in."; }
    static get ERR_API_LOGIN_FAILED(){ return "Invalid email/password combination"; }
    static get ERR_API_SESSION_TIMEOUT(){ return "Session Timeout. Please log in."; }

    static getUserMicropost(user_id, page){
        return new Promise( (resolve, reject) => {
            axios.get('/api/users/' + user_id, {
                params: {
                    page: page
                }
            }).then(function(response){
                resolve( response.data.micropost );
            })
            .catch(function(error){
                reject(Api.ERR_API_SESSION_TIMEOUT);   
            });
        });
    }

    static getApiToken(){
        let api_token = localStorage.getItem("api_token");
        if(api_token === null) throw Api.ERR_API_TOKEN_NOT_FOUND;
        return api_token;
    }

    static isExistApiToken(){
        return !!localStorage.getItem("api_token");
    }

    static getUsers(page){
        return new Promise( (resolve, reject ) => {
            let api_token = this.getApiToken();
            axios.get('/api/users/', {
                params:{
                    page: page
                },
                headers: {
                    'Authorization': api_token
                }
            }).then(function(response){
                response.result = true;
                resolve(response);
            })
            .catch(function(error){
                reject(Api.ERR_API_SESSION_TIMEOUT);
            });
        });
    }

    static Login(email, password){
        return new Promise( (resolve, reject) => {
            axios.post('/api/login/', {
                email: email,
                password: password
            }).then(function(response){
                localStorage.setItem("api_token", response.data.access_token);
                resolve(response.data);
            })
            .catch(function(error){
                reject(Api.ERR_API_LOGIN_FAILED);
            });
        });
    }

    static getMyFeed(page){
        return new Promise( (resolve, reject) => {
            let api_token = this.getApiToken();
            axios.get('/api/feed/', {
                params: {
                    page: page
                },
                headers: {
                    'Authorization': api_token
                }
            }).then(function(response){
                response.result = true;
                resolve(response);
            })
            .catch(function(error){
                reject(Api.ERR_API_SESSION_TIMEOUT);
            });
        });
    }
}
