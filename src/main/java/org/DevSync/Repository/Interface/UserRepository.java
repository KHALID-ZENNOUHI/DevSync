package org.DevSync.Repository.Interface;

import org.DevSync.Domain.User;

import javax.swing.text.html.Option;
import java.util.List;
import java.util.Optional;

public interface UserRepository {
    User create(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    User update(User user);
    void delete(Long id);
    List<User> findAll();
}