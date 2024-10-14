package org.DevSync.Repository.Implementation;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.Domain.Jeton;
import org.DevSync.Domain.User;
import org.DevSync.Repository.Interface.JetonRepository;

import java.util.List;
import java.util.Optional;

public class JetonRepositoryImpl implements JetonRepository {
    private final EntityManagerFactory emf;
    public JetonRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }
    @Override
    public Jeton create(Jeton jeton) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(jeton);
        em.getTransaction().commit();
        em.close();
        return jeton;
    }

    @Override
    public Optional<Jeton> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<Jeton> jeton = Optional.ofNullable(em.find(Jeton.class, id));
        em.getTransaction().commit();
        em.close();
        return jeton;
    }

    @Override
    public Jeton update(Jeton jeton) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Jeton updatedJeton = em.merge(jeton);
        em.getTransaction().commit();
        em.close();
        return updatedJeton;
    }

    @Override
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Jeton jeton = em.find(Jeton.class, id);
        em.remove(jeton);
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public void deleteAllInResetDate() {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.createQuery("DELETE FROM Jeton j WHERE j.lastResetDate < CURRENT_DATE").executeUpdate();
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public Jeton findUserJetons(User user) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Jeton jeton = em.createQuery("SELECT j FROM Jeton j WHERE j.user = :user", Jeton.class)
                .setParameter("user", user)
                .getSingleResult();
        em.getTransaction().commit();
        em.close();
        return jeton;
    }

    @Override
    public List<Jeton> findAll() {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        List<Jeton> jetons = em.createQuery("SELECT j FROM Jeton j", Jeton.class).getResultList();
        em.getTransaction().commit();
        em.close();
        return jetons;
    }
}
