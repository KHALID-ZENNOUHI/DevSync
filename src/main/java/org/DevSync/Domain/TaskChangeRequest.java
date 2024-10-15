package org.DevSync.Domain;

import jakarta.persistence.*;

import java.time.LocalDateTime;
@Entity
@Table(name = "task_change_requests")
public class TaskChangeRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "task_id", nullable = false)
    private Task task;

    @ManyToOne
    @JoinColumn(name = "requested_by", nullable = false)
    private User requestedBy;

    @Column(name = "change_date", nullable = false)
    private LocalDateTime changeDate;

    public TaskChangeRequest() {
    }

    public TaskChangeRequest(Task task, User requestedBy, LocalDateTime changeDate) {
        this.task = task;
        this.requestedBy = requestedBy;
        this.changeDate = changeDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public User getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(User requestedBy) {
        this.requestedBy = requestedBy;
    }

    public LocalDateTime getChangeDate() {
        return changeDate;
    }

    public void setChangeDate(LocalDateTime changeDate) {
        this.changeDate = changeDate;
    }
}
