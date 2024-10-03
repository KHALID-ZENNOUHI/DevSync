package org.DevSync.Repository.Implementation;

import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.Domain.User;
import org.DevSync.Repository.Interface.UserRepository;

import java.util.List;

public class UserRepositoryImpl implements UserRepository {
    private final EntityManagerFactory emf;

    public UserRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }

    @Override
    public void create(User user) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(user);
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public User read(Long id) {
        EntityManager em = emf.createEntityManager();
        User user = em.find(User.class, id);
        em.close();
        return user;
    }

    @Override
    public void update(User user) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(user);
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public void delete(Long userId) {
        EntityManager em = emf.createEntityManager();  // Assuming you have an EntityManagerFactory
        User user = em.find(User.class, userId);
        if (user != null) {
            em.getTransaction().begin();
            em.remove(user);
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
