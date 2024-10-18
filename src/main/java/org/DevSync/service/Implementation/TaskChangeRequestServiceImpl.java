package org.DevSync.service.Implementation;

import org.DevSync.domain.TaskChangeRequest;
import org.DevSync.repository.Implementation.TaskChangeRequestRepositoryImpl;
import org.DevSync.repository.Interface.TaskChangeRequestRepository;
import org.DevSync.service.Interface.TaskChangeRequestService;

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
    public Optional<TaskChangeRequest> findByUserId(Long userId) {
        return this.taskChangeRequestRepository.findByUserId(userId).stream().findFirst();
    }

    @Override
    public Optional<TaskChangeRequest> findByTaskId(Long taskId) {
        return this.taskChangeRequestRepository.findByTaskId(taskId).stream().findFirst();
    }

}
