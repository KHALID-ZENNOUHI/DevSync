package org.DevSync.repository.Interface;

import org.DevSync.domain.TaskChangeRequest;

import java.util.List;
import java.util.Optional;

public interface TaskChangeRequestRepository {
    TaskChangeRequest create(TaskChangeRequest taskChangeRequest);
    Optional<TaskChangeRequest> findById(Long id);
    TaskChangeRequest update(TaskChangeRequest taskChangeRequest);
    void delete(Long id);
    List<TaskChangeRequest> findAll();
    List<TaskChangeRequest> findByUserId(Long userId);
    List<TaskChangeRequest> findByTaskId(Long taskId);
}
