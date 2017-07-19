const axios = require('axios')
export default class get_from_api{

    get_users_microposts(user_id){
        axios.get('/api/users/' + user_id).then(function(response){
            console.log(response);   
            return response.data.micropost;
        })
        .catch(function(error){
            console.log(error);   
        });
    }
}
