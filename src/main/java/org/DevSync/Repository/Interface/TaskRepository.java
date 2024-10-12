package org.DevSync.Repository.Interface;

import org.DevSync.Domain.Task;

import java.util.List;
import java.util.Optional;

public interface TaskRepository {
    Task create(Task task);
    Optional<Task> findById(Long id);
    Task update(Task task);
    void delete(Long id);
    List<Task> findAll();
    List<Task> findByUserId(Long userId);
}
