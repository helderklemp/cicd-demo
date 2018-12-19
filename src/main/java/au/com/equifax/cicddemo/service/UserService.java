package au.com.equifax.cicddemo.service;

import au.com.equifax.cicddemo.domain.User;

import java.util.Collection;
import java.util.Optional;

public interface UserService {

    User save(User user);

    int getUsersTotal();

    Collection<User> getUsers();

    Optional<User> findById(long id);
}
