package org.DevSync.service.Implementation;

import org.DevSync.domain.Jeton;
import org.DevSync.domain.User;
import org.DevSync.repository.Implementation.JetonRepositoryImpl;
import org.DevSync.repository.Interface.JetonRepository;
import org.DevSync.service.Interface.JetonService;

import java.util.List;
import java.util.Optional;

public class JetonServiceImpl implements JetonService {
    private final JetonRepository jetonRepository;
    public JetonServiceImpl() {
        this.jetonRepository = new JetonRepositoryImpl();
    }

    @Override
    public Jeton create(Jeton jeton) {
        return jetonRepository.create(jeton);
    }

    @Override
    public Optional<Jeton> findById(Long id) {
        return jetonRepository.findById(id);
    }

    @Override
    public Jeton update(Jeton jeton) {
        return jetonRepository.update(jeton);
    }

    @Override
    public void delete(Long id) {
        jetonRepository.delete(id);
    }

    @Override
    public void deleteAllInResetDate() {
        jetonRepository.deleteAllInResetDate();
    }

    @Override
    public Jeton findJetonByUser(User user) {
        return jetonRepository.findJetonByUser(user);
    }


    @Override
    public List<Jeton> findAll() {
        return jetonRepository.findAll();
    }
}
