package org.DevSync.repository.Implementation;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.DevSync.domain.Task;
import org.DevSync.repository.Interface.TaskRepository;

import java.util.List;
import java.util.Optional;

public class TaskRepositoryImpl implements TaskRepository {
    private EntityManagerFactory emf;

    public TaskRepositoryImpl() {
        this.emf = Persistence.createEntityManagerFactory("myPersistenceUnit");
    }

    @Override
    public Task create(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(task);
        em.getTransaction().commit();
        em.close();
        return task;
    }

    @Override
    public Optional<Task> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<Task> task = Optional.ofNullable(em.find(Task.class, id));
        em.getTransaction().commit();
        em.close();
        return task;
    }

    @Override
    public Task update(Task task) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(task);
        em.getTransaction().commit();
        em.close();
        return task;
    }

    @Override
    public void delete(Long id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Optional<Task> taskOptional = findById(id);
        if (taskOptional.isPresent()) {
            Task task = taskOptional.get();
            if (em.contains(task)) {
                em.remove(task);
            } else {
                em.remove(em.merge(task));
            }
            em.getTransaction().commit();
        }
        em.close();
    }

    @Override
    public List<Task> findAll() {
        EntityManager em = emf.createEntityManager();
        List<Task> tasks = em.createQuery("SELECT t FROM Task t", Task.class).getResultList();
        em.close();
        return tasks;
    }

    @Override
    public List<Task> findByUserId(Long userId) {
        EntityManager em = emf.createEntityManager();
        List<Task> tasks = em.createQuery("SELECT t FROM Task t WHERE t.assignedTo.id = :userId", Task.class)
                .setParameter("userId", userId)
                .getResultList();
        em.close();
        return tasks;
    }

}
