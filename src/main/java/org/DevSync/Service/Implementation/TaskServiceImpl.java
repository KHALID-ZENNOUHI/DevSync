package org.DevSync.Service.Implementation;

import org.DevSync.Domain.Task;
import org.DevSync.Repository.Implementation.TaskRepositoryImpl;
import org.DevSync.Repository.Interface.TaskRepository;
import org.DevSync.Service.Interface.TaskService;

import java.util.List;
import java.util.Optional;

public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;

    public TaskServiceImpl() {
        this.taskRepository = new TaskRepositoryImpl();
    }

    @Override
    public Task create(Task task) {
        validateTask(task);
        return this.taskRepository.create(task);
    }

    @Override
    public Optional<Task> findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Task ID cannot be null");
        }
        return this.taskRepository.findById(id);
    }

    @Override
    public Task update(Task task) {
        validateTask(task);
        return this.taskRepository.update(task);
    }

    @Override
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Task ID cannot be null");
        }
        this.taskRepository.delete(id);
    }

    @Override
    public List<Task> findAll() {
        return this.taskRepository.findAll();
    }

    @Override
    public List<Task> findByUserId(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        return this.taskRepository.findByUserId(userId);
    }

    public void validateTask(Task task) {
        if (task == null) {
            throw new IllegalArgumentException("Task cannot be null");
        } else if (task.getTitle() == null || task.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Task title cannot be empty");
        } else if (task.getDescription() == null || task.getDescription().isEmpty()) {
            throw new IllegalArgumentException("Task description cannot be empty");
        } else if (task.getDeadline() == null) {
            throw new IllegalArgumentException("Task due date cannot be null");
        } else if (task.getCreated_at() == null) {
            throw new IllegalArgumentException("Task creation date cannot be null");
        } else if (task.getAssignedTo() == null) {
            throw new IllegalArgumentException("Task assignee cannot be null");
        } else if (task.getTaskStatus() == null) {
            throw new IllegalArgumentException("Task completion status cannot be null");
        } else if (task.getCreatedBy() == null) {
            throw new IllegalArgumentException("Task creator cannot be null");
        } else if (task.getTags() == null || task.getTags().isEmpty() || task.getTags().size() < 2) {
            throw new IllegalArgumentException("Task must have at least two tags");
        }
    }
}
