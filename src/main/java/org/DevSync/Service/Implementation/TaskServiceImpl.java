package org.DevSync.Service.Implementation;

import org.DevSync.Domain.Enum.TaskStatus;
import org.DevSync.Domain.Task;
import org.DevSync.Repository.Implementation.TaskRepositoryImpl;
import org.DevSync.Repository.Interface.TaskRepository;
import org.DevSync.Service.Interface.TagService;
import org.DevSync.Service.Interface.TaskService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class TaskServiceImpl implements TaskService {
    private final TaskRepository taskRepository;
    private final TagService tagService;

    public TaskServiceImpl() {
        this.taskRepository = new TaskRepositoryImpl();
        this.tagService = new TagServiceImpl();
    }

    @Override
    public Task create(Task task) {
        validateTask(task);
        checkIfStartDateIsBeforeEndDate(task);
        checkIfDeadlineIsAfterThreeDaysOfStartDate(task);
        enforceTaskCompletionBeforeDeadline(task);
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
        checkIfStartDateIsBeforeEndDate(task);
        checkIfDeadlineIsAfterThreeDaysOfStartDate(task);
        enforceTaskCompletionBeforeDeadline(task);
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

    public void checkIfDeadlineIsAfterThreeDaysOfStartDate(Task task) {
        if (task.getDeadline().isBefore(task.getCreated_at().plusDays(3))) {
            throw new IllegalArgumentException("Task deadline must be at least 3 days after start date");
        }
    }

    public void checkIfStartDateIsBeforeEndDate(Task task) {
        if (task.getCreated_at().isAfter(task.getDeadline())) {
            throw new IllegalArgumentException("Task start date must be before end date");
        }
    }

    public void enforceTaskCompletionBeforeDeadline(Task task) {
        if (task.getTaskStatus() == TaskStatus.COMPLETED && LocalDateTime.now().isAfter(task.getDeadline())) {
            throw new IllegalArgumentException("Task cannot be marked as completed after the deadline");
        }
    }
}
