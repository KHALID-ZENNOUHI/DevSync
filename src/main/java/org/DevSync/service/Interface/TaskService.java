package org.DevSync.service.Interface;

import org.DevSync.domain.Task;

import java.util.List;
import java.util.Optional;

public interface TaskService {
    Task create(Task task);
    Optional<Task> findById(Long id);
    Task update(Task task);
    void delete(Long id);
    List<Task> findAll();
    List<Task> findByUserId(Long userId);
}
