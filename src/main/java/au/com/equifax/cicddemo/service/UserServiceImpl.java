package au.com.equifax.cicddemo.service;


import au.com.equifax.cicddemo.domain.User;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService{
    private Collection<User> users = new ArrayList<>();

    @Override
    public User save(User user) {
        if(user!=null && user.getLogin() != null){
            users.add(user);
        }else{
            throw new IllegalArgumentException();
        }
        return user;
    }

    @Override
    public int getUsersTotal() {
        return users.size();
    }

    @Override
    public Collection<User> getUsers() {

        return users;
    }

    @Override
    public Optional<User> findById(long id) {
        return users.stream().filter(user -> (user.getId()==id)).findFirst();
    }
}
