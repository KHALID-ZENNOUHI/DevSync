package org.DevSync.Repository.Implementation;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.Domain.TaskChangeRequest;
import org.DevSync.Repository.Interface.TaskChangeRequestRepository;

import java.util.List;
import java.util.Optional;

public class TaskChangeRequestRepositoryImpl implements TaskChangeRequestRepository {
    private EntityManagerFactory emf;

    public TaskChangeRequestRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }

    @Override
    public TaskChangeRequest create(TaskChangeRequest taskChangeRequest) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(taskChangeRequest);
        em.getTransaction().commit();
        em.close();
        return taskChangeRequest;
    }

    @Override
    public Optional<TaskChangeRequest> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<TaskChangeRequest> taskChangeRequest = Optional.ofNullable(em.find(TaskChangeRequest.class, id));
        em.getTransaction().commit();
        em.close();
        return taskChangeRequest;
    }

    @Override
    public TaskChangeRequest update(TaskChangeRequest taskChangeRequest) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(taskChangeRequest);
        em.getTransaction().commit();
        em.close();
        return taskChangeRequest;
    }

    @Override
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<TaskChangeRequest> taskChangeRequestOptional = findById(id);
        if (taskChangeRequestOptional.isPresent()) {
            TaskChangeRequest taskChangeRequest = taskChangeRequestOptional.get();
            if (em.contains(taskChangeRequest)) {
                em.remove(taskChangeRequest);
            } else {
                em.remove(em.merge(taskChangeRequest));
            }
        }
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public List<TaskChangeRequest> findAll() {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        List<TaskChangeRequest> taskChangeRequests = em.createQuery("SELECT t FROM TaskChangeRequest t", TaskChangeRequest.class).getResultList();
        em.getTransaction().commit();
        em.close();
        return taskChangeRequests;
    }

    @Override
    public List<TaskChangeRequest> findByUserId(Long userId) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        List<TaskChangeRequest> taskChangeRequests = em.createQuery("SELECT t FROM TaskChangeRequest t WHERE t.user.id = :userId", TaskChangeRequest.class)
                .setParameter("userId", userId)
                .getResultList();
        em.getTransaction().commit();
        em.close();
        return taskChangeRequests;
    }
}
