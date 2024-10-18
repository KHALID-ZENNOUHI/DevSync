package org.DevSync.service.Implementation;


import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import org.DevSync.domain.Enum.TaskStatus;
import org.DevSync.domain.Jeton;
import org.DevSync.domain.Task;
import org.DevSync.repository.Implementation.JetonRepositoryImpl;
import org.DevSync.repository.Implementation.TaskRepositoryImpl;
import org.DevSync.repository.Interface.JetonRepository;
import org.DevSync.repository.Interface.TaskRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;


@Singleton
@Startup
public class SchedulerService {

    private final TaskRepository taskRepository;

    private final JetonRepository jetonRepository;

    public SchedulerService() {
        this.taskRepository = new TaskRepositoryImpl();
        this.jetonRepository = new JetonRepositoryImpl();
    }

    @Schedule(hour = "0", minute = "0", second = "0", persistent = false)
    public void markOverdueTasks() {
        LocalDateTime now = LocalDateTime.now();
        List<Task> overdueTasks = taskRepository.findAll().stream()
                .filter(task -> task.getTaskStatus() != TaskStatus.COMPLETED
                        && task.getTaskStatus() != TaskStatus.CANCELLED
                        && task.getDeadline().isBefore(now))
                .collect(Collectors.toList());

        for (Task task : overdueTasks) {
            task.setTaskStatus(TaskStatus.CANCELLED);
            taskRepository.update(task);
        }
    }

    @Schedule(hour = "0", minute = "0", second = "0", persistent = false)
    public void resetDailyJetons() {
        List<Jeton> allJetons = jetonRepository.findAll();
        for (Jeton Jeton : allJetons) {
            Jeton.setChangeJeton(2);
            jetonRepository.create(Jeton);
        }
    }

    @Schedule(hour = "0", minute = "0", dayOfMonth = "1", persistent = false)
    public void resetMonthlyJetons() {
        List<Jeton> allJetons = jetonRepository.findAll();
        for (Jeton Jeton : allJetons) {
            Jeton.setDeleteJeton(1);
            jetonRepository.create(Jeton);
        }
    }

    // Add a new method to reset evry second

//    @Schedule(hour = "*", minute = "*", second = "0", persistent = false)
//    public void resetSecondJetons() {
//        List<Jeton> allJetons = JetonRepository.findAll();
//        for (Jeton Jeton : allJetons) {
//            Jeton.setDeleteJeton(10);
//            Jeton.setLastResetDate(LocalDateTime.now());
//            JetonRepository.create(Jeton);
//        }
//    }
}
