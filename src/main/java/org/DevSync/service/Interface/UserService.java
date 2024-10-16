package org.DevSync.service.Interface;

import org.DevSync.domain.User;

import java.util.List;
import java.util.Optional;

public interface UserService {
    User create(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    User update(User user);
    void delete(Long id);
    List<User> findAll();
}
