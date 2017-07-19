const axios = require('axios')
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
}
