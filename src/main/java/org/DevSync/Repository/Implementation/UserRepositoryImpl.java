package org.DevSync.Repository.Implementation;

import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.Domain.User;
import org.DevSync.Repository.Interface.UserRepository;

import java.util.List;
import java.util.Optional;

public class UserRepositoryImpl implements UserRepository {
    private final EntityManagerFactory emf;

    public UserRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }

    @Override
    public User create(User user) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(user);
        em.getTransaction().commit();
        em.close();
        return user;
    }

    @Override
    public Optional<User> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        Optional<User> user = Optional.ofNullable(em.find(User.class, id));
        em.close();
        return user;
    }

    @Override
    public Optional<User> findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        Optional<User> user = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultList()
                .stream()
                .findFirst();
        em.close();
        return user;
    }

    @Override
    public User update(User user) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(user);
        em.getTransaction().commit();
        em.close();
        return user;
    }

    @Override
    public void delete(Long userId) {
        EntityManager em = emf.createEntityManager();  // Assuming you have an EntityManagerFactory
        Optional<User> userOptional = findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            em.getTransaction().begin();
            if (em.contains(user)) {
                em.remove(user);
            } else {
                em.remove(em.merge(user));
            }
            em.getTransaction().commit();
        }
        em.close();
    }

    @Override
    public List<User> findAll() {
        EntityManager em = emf.createEntityManager();
        List<User> users = em.createQuery("SELECT u FROM User u", User.class).getResultList();
        em.close();
        return users;
    }
}
