package org.DevSync.Repository.Implementation;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.Domain.Tag;
import org.DevSync.Domain.Task;
import org.DevSync.Repository.Interface.TagRepository;

import java.util.List;
import java.util.Optional;

public class TagRepositoryImpl implements TagRepository {
    private EntityManagerFactory emf;

    public TagRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }

    @Override
    public Tag create(Tag tag) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(tag);
        em.getTransaction().commit();
        em.close();
        return tag;
    }

    @Override
    public Optional<Tag> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<Tag> tag = Optional.ofNullable(em.find(Tag.class, id));
        em.getTransaction().commit();
        em.close();
        return tag;
    }

    @Override
    public Optional<Tag> findByName(String name) {
        EntityManager em = emf.createEntityManager();
        try {
            // Use JPQL to query by name
            Tag tag = em.createQuery("SELECT t FROM Tag t WHERE t.name = :name", Tag.class)
                    .setParameter("name", name)
                    .getSingleResult();
            return Optional.ofNullable(tag);
        } catch (Exception e) {
            // Catch exceptions like NoResultException to handle no result case
            return Optional.empty();
        } finally {
            em.close();
        }
    }


    @Override
    public Tag update(Tag tag) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(tag);
        em.getTransaction().commit();
        em.close();
        return tag;
    }

    @Override
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<Tag> tagOptional = findById(id);
        if (tagOptional.isPresent()) {
            Tag tag = tagOptional.get();
            if (em.contains(tag)) {
                em.remove(tag);
            } else {
                em.remove(em.merge(tag));
            }
            em.getTransaction().commit();
        }
        em.close();
    }

    @Override
    public List<Tag> findAll() {
        EntityManager em = emf.createEntityManager();
        List<Tag> tags = em.createQuery("SELECT t FROM Tag t", Tag.class).getResultList();
        em.close();
        return tags;
    }
}
