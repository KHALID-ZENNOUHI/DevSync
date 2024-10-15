package org.DevSync.Servlet;

import org.DevSync.Domain.Enum.TaskStatus;
import org.DevSync.Domain.Jeton;
import org.DevSync.Domain.Task;
import org.DevSync.Domain.TaskChangeRequest;
import org.DevSync.Domain.User;
import org.DevSync.Service.Implementation.JetonServiceImpl;
import org.DevSync.Service.Implementation.TaskChangeRequestServiceImpl;
import org.DevSync.Service.Implementation.TaskServiceImpl;
import org.DevSync.Service.Interface.JetonService;
import org.DevSync.Service.Interface.TaskChangeRequestService;
import org.DevSync.Service.Interface.TaskService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class TaskChangeRequestScheduler {
    private final ScheduledExecutorService scheduler;
    private final JetonService jetonService;
    private final TaskService taskService;
    private final TaskChangeRequestService taskChangeRequestService;

    public TaskChangeRequestScheduler() {
        this.scheduler = Executors.newSingleThreadScheduledExecutor();
        this.jetonService = new JetonServiceImpl();
        this.taskService = new TaskServiceImpl();
        this.taskChangeRequestService = new TaskChangeRequestServiceImpl();
    }

    public void start() {
        scheduler.scheduleAtFixedRate(this::checkAndUpdateTaskChangeRequests, 0, 1, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(this::checkAndUpdateTasks, 0, 1, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(this::resetJetons, 0, 1, TimeUnit.SECONDS);
    }

    private void resetJetons() {
        List<Jeton> Jetons = jetonService.findAll();
        for (Jeton jeton : Jetons) {
            if (jeton.getLastResetDate().plusDays(1).isBefore(LocalDateTime.now())) {
                jeton.setChangeJeton(jeton.getResetChangeJetons() + jeton.getChangeJeton());
                jeton.setLastResetDate(LocalDateTime.now());
                jeton.setResetChangeJetons(0);
                jetonService.update(jeton);
            }
            if (LocalDateTime.now().getDayOfMonth() == 1) {
                jeton.setDeleteJeton(jeton.getResetDeleteJetons() + jeton.getDeleteJeton());
                jeton.setResetDeleteJetons(0);
                jetonService.update(jeton);
            }
        }
    }

    private void checkAndUpdateTasks() {
        List<Task> tasks = taskService.findAll();
        for (Task task : tasks) {
            if (task.getDeadline().isBefore(LocalDateTime.now()) && task.getTaskStatus() != TaskStatus.COMPLETED) {
                task.setTaskStatus(TaskStatus.CANCELLED);
                taskService.update(task);
            }
        }
    }

    private void checkAndUpdateTaskChangeRequests() {
        List<TaskChangeRequest> taskChanges = taskChangeRequestService.findAll();
        for (TaskChangeRequest taskChange : taskChanges) {
            if (taskChange.getChangeDate().plusHours(12).isBefore(LocalDateTime.now())){
                User user = taskChange.getRequestedBy();
                Jeton jeton = jetonService.findJetonByUser(user);
                jeton.setResetChangeJetons(jeton.getResetChangeJetons() + 2);
                jetonService.update(jeton);
                taskChangeRequestService.delete(taskChange.getId());
            }
            if (taskChange.getTask().getTaskStatus().name().equalsIgnoreCase("CANCELLED")){
                taskChangeRequestService.delete(taskChange.getId());
            }
        }
    }

}
