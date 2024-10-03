package org.DevSync.Service.Implementation;

import org.DevSync.Domain.User;
import org.DevSync.Repository.Implementation.UserRepositoryImpl;
import org.DevSync.Repository.Interface.UserRepository;
import org.DevSync.Service.Interface.UserService;

import java.util.List;

public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    public UserServiceImpl() {
        this.userRepository = new UserRepositoryImpl();
    }
    @Override
    public void create(User user) {
        userRepository.create(user);
    }

    @Override
    public User read(Long id) {
        return userRepository.read(id);
    }

    @Override
    public void update(User user) {
        userRepository.update(user);
    }

    @Override
    public void delete(Long id) {
        userRepository.delete(id);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }
}
