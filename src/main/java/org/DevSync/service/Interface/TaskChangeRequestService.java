package org.DevSync.service.Interface;

import org.DevSync.domain.TaskChangeRequest;

import java.util.List;
import java.util.Optional;

public interface TaskChangeRequestService {
    TaskChangeRequest create(TaskChangeRequest taskChangeRequest);
    Optional<TaskChangeRequest> findById(Long id);
    TaskChangeRequest update(TaskChangeRequest taskChangeRequest);
    void delete(Long id);
    List<TaskChangeRequest> findAll();
    Optional<TaskChangeRequest> findByUserId(Long userId);
    Optional<TaskChangeRequest> findByTaskId(Long taskId);
}
