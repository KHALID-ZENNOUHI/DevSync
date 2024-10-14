package org.DevSync.Service.Implementation;

import org.DevSync.Domain.Jeton;
import org.DevSync.Domain.User;
import org.DevSync.Repository.Implementation.JetonRepositoryImpl;
import org.DevSync.Repository.Interface.JetonRepository;
import org.DevSync.Service.Interface.JetonService;

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
    public Jeton findUserJetons(User user) {
        return jetonRepository.findUserJetons(user);
    }


    @Override
    public List<Jeton> findAll() {
        return jetonRepository.findAll();
    }
}
