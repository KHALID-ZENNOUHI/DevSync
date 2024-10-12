package org.DevSync.Service.Implementation;

import org.DevSync.Domain.User;
import org.DevSync.Repository.Implementation.UserRepositoryImpl;
import org.DevSync.Repository.Interface.UserRepository;
import org.DevSync.Service.Interface.UserService;

import java.util.List;
import java.util.Optional;

public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    public UserServiceImpl() {
        this.userRepository = new UserRepositoryImpl();
    }
    @Override
    public User create(User user) {
        validateUser(user);
        checkUserExists(user);
        return userRepository.create(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User update(User user) {
        validateUser(user);
        return userRepository.update(user);
    }

    @Override
    public void delete(Long id) {
        userRepository.delete(id);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    public void validateUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        if (user.getUsername() == null || user.getUsername().equals("")) {
            throw new IllegalArgumentException("User username cannot be null or empty");
        }
        if (user.getEmail() == null || user.getEmail().equals("")) {
            throw new IllegalArgumentException("User email cannot be null or empty");
        }
        if (user.getFirstName() == null || user.getFirstName().equals("")) {
            throw new IllegalArgumentException("User name cannot be null or empty");
        }
        if (user.getLastName() == null || user.getLastName().equals("")) {
            throw new IllegalArgumentException("User name cannot be null or empty");
        }
        if (user.getPassword() == null || user.getPassword().equals("")) {
            throw new IllegalArgumentException("User password cannot be null or empty");
        }
    }

    public void checkUserExists(User user) {
        findByEmail(user.getEmail()).ifPresent(u -> {
            throw new IllegalArgumentException("User with email " + user.getEmail() + " already exists");
        }) ;
    }
}
