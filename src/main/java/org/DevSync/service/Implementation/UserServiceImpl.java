package org.DevSync.service.Implementation;

import org.DevSync.domain.User;
import org.DevSync.exceptions.*;
import org.DevSync.repository.Interface.UserRepository;
import org.DevSync.service.Interface.UserService;

import java.util.List;
import java.util.Optional;

public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    @Override
    public User create(User user) {
        validateUser(user);
        checkUserExists(user);
        checkIfIDExists(user);
        return userRepository.create(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) throw new IllegalArgumentException(email);
        return userRepository.findByEmail(email);
    }

    @Override
    public User update(User user) {
        validateUser(user);
        checkIfIDNullOrInValid(user.getId());
        if (findById(user.getId()).isPresent()) return userRepository.update(user);
        else throw new UserNotFoundException();

    }

    @Override
    public void delete(Long id) {
        checkIfIDNullOrInValid(id);
        if (findById(id).isPresent()) userRepository.delete(id);
        else throw new UserNotFoundException();
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    public void validateUser(User user) {
        if (user == null) {
            throw new NullUserException();
        }
        if (user.equals(new User())) {
            throw new EmptyUserException();
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new InvalidArgumentException();
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new InvalidArgumentException();
        }
        if (user.getFirstName() == null || user.getFirstName().trim().isEmpty()) {
            throw new InvalidArgumentException();
        }
        if (user.getLastName() == null || user.getLastName().trim().isEmpty()) {
            throw new InvalidArgumentException();
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new InvalidArgumentException();
        }
    }

    public void checkUserExists(User user) {
        findByEmail(user.getEmail()).ifPresent(u -> {
            throw new ExistUserException(u.getEmail());
        }) ;
    }

    public void checkIfIDExists(User user) {
        if (user.getId() != null) throw new PreAssignedIdException();
    }

    public void checkIfIDNullOrInValid(Long id) {
        if (id == null || id <= 0) throw new NullOrInvalidID();
    }
}
