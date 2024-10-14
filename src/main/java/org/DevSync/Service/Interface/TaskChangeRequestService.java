package org.DevSync.Service.Interface;

import org.DevSync.Domain.TaskChangeRequest;

import java.util.List;
import java.util.Optional;

public interface TaskChangeRequestService {
    TaskChangeRequest create(TaskChangeRequest taskChangeRequest);
    Optional<TaskChangeRequest> findById(Long id);
    TaskChangeRequest update(TaskChangeRequest taskChangeRequest);
    void delete(Long id);
    List<TaskChangeRequest> findAll();
    List<TaskChangeRequest> findByUserId(Long userId);
}
