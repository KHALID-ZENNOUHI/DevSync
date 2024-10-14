package org.DevSync.Service.Implementation;

import org.DevSync.Domain.TaskChangeRequest;
import org.DevSync.Repository.Implementation.TaskChangeRequestRepositoryImpl;
import org.DevSync.Repository.Interface.TaskChangeRequestRepository;
import org.DevSync.Service.Interface.TaskChangeRequestService;

import java.util.List;
import java.util.Optional;

public class TaskChangeRequestServiceImpl implements TaskChangeRequestService {
    private final TaskChangeRequestRepository taskChangeRequestRepository;

    public TaskChangeRequestServiceImpl() {
        this.taskChangeRequestRepository = new TaskChangeRequestRepositoryImpl();
    }

    @Override
    public TaskChangeRequest create(TaskChangeRequest taskChangeRequest) {
        return this.taskChangeRequestRepository.create(taskChangeRequest);
    }

    @Override
    public Optional<TaskChangeRequest> findById(Long id) {
        return this.taskChangeRequestRepository.findById(id);
    }

    @Override
    public TaskChangeRequest update(TaskChangeRequest taskChangeRequest) {
        return this.taskChangeRequestRepository.update(taskChangeRequest);
    }

    @Override
    public void delete(Long id) {
        this.taskChangeRequestRepository.delete(id);
    }

    @Override
    public List<TaskChangeRequest> findAll() {
        return this.taskChangeRequestRepository.findAll();
    }

    @Override
    public List<TaskChangeRequest> findByUserId(Long userId) {
        return this.taskChangeRequestRepository.findByUserId(userId);
    }
}
