package org.DevSync.Service.Interface;

import org.DevSync.Domain.Jeton;
import org.DevSync.Domain.User;

import java.util.List;
import java.util.Optional;

public interface JetonService {
    Jeton create(Jeton jeton);
    Optional<Jeton> findById(Long id);
    Jeton update(Jeton jeton);
    void delete(Long id);
    void deleteAllInResetDate();
    Jeton findJetonByUser(User user);
    List<Jeton> findAll();
}
