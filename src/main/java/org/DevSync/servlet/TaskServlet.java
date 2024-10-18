    package org.DevSync.servlet;

    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import org.DevSync.domain.*;
    import org.DevSync.domain.Enum.TaskStatus;
    import org.DevSync.domain.Enum.UserType;
    import org.DevSync.repository.Implementation.UserRepositoryImpl;
    import org.DevSync.service.Implementation.*;
    import org.DevSync.service.Interface.*;
    import com.fasterxml.jackson.databind.ObjectMapper;
    import java.io.BufferedReader;
    import java.io.IOException;
    import java.time.LocalDateTime;
    import java.util.Arrays;
    import java.util.Collections;
    import java.util.List;
    import java.util.Optional;
    import java.util.stream.Collectors;

    @WebServlet("/task")
    public class TaskServlet extends HttpServlet {
        private TaskService taskService;
        private TagService tagService;
        private UserService userService;
        private TaskChangeRequestService taskChangeRequestService;
        private JetonService jetonService;

        @Override
        public void init() throws ServletException {
            this.taskService = new TaskServiceImpl();
            this.tagService = new TagServiceImpl();
            this.userService = new UserServiceImpl(new UserRepositoryImpl());
            this.taskChangeRequestService = new TaskChangeRequestServiceImpl();
            this.jetonService = new JetonServiceImpl();
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            list(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String action = req.getParameter("action");
            if ("create".equals(action)) create(req, resp);
            else if ("update".equals(action)) update(req, resp);
            else if ("delete".equals(action)) delete(req, resp);
            else if ("request".equals(action)) handleTaskChangeRequest(req, resp);
            else{
                updateStatus(req, resp);
            }
        }

        public void create(HttpServletRequest request, HttpServletResponse response) throws IOException {
            Task task = getAllAttributes(request);
            Task savedTask = taskService.create(task);
            request.setAttribute("message", "the task " + savedTask.getTitle() + "created successfully!");
            response.sendRedirect("task?action=list");
        }

        public void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
            Task task = getAllAttributes(request);
            Task updatedTask = taskService.update(task);
            request.setAttribute("message", "The task " + updatedTask.getTitle() + "updated successfully!");
            response.sendRedirect("task?action=list");
        }

        public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                // Read JSON from the request body
                BufferedReader reader = request.getReader();
                ObjectMapper mapper = new ObjectMapper();
                Task taskRequest = mapper.readValue(reader, Task.class);

                // Process the task update
                Long taskId = taskRequest.getId();
                String newStatus = taskRequest.getTaskStatus().name();

                Task task = taskService.findById(taskId)
                        .orElseThrow(() -> new IllegalArgumentException("Task not found"));

                task.setTaskStatus(TaskStatus.valueOf(newStatus));

                // Send success response
                response.getWriter().write("{\"message\": \"Task status updated successfully\"}");

            } catch (Exception e) {
                // Handle error and send JSON error response
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"message\": \"Error updating task\"}");
                e.printStackTrace();
            }
        }


        public void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            User logedUser = (User) request.getSession().getAttribute("user");
            Long id = Long.parseLong(request.getParameter("id"));

            if (logedUser.getUserType() == UserType.MANAGER) {
                taskService.delete(id);
                request.setAttribute("message", "Task deleted successfully!");
                response.sendRedirect("task");
            } else if (logedUser.getUserType() == UserType.USER) {
                Task task = taskService.findById(id).orElseThrow(() -> new IllegalArgumentException("Task not found"));
                if (task.getCreatedBy().getId().equals(logedUser.getId())) {
                    taskService.delete(id);
                    request.setAttribute("message", "Task deleted successfully!");
                    response.sendRedirect("task");
                } else {
                        Jeton jeton = logedUser.getJeton();
                        if (jeton.getDeleteJeton() > 0) {
                            taskService.delete(id);
                            jeton.setDeleteJeton(jeton.getDeleteJeton() - 1);
                            jetonService.update(jeton);
                            request.setAttribute("message", "Task deleted successfully!");
                            response.sendRedirect("task");
                        } else {
                            request.setAttribute("message", "You don't have enough jetons to delete this task!");
                            response.sendRedirect("task");
                        }
                }

            }else {
                request.setAttribute("message", "You don't have permission to delete this task!");
                response.sendRedirect("task");
            }
        }

        public void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            User logedUser = (User) request.getSession().getAttribute("user");
            List<Tag> tags = tagService.findAll();
            List<User> users = userService.findAll().stream().filter(user -> user.getUserType() == UserType.USER).collect(Collectors.toList());
            List<Task> tasks;
            if (logedUser.getUserType() == UserType.USER) {
                tasks = taskService.findByUserId(logedUser.getId());
            } else {
                tasks = taskService.findAll();
            }
            filterTasksByStatus(tasks, request);
            request.setAttribute("tags", tags);
            request.setAttribute("users", users);
            request.getRequestDispatcher("task.jsp").forward(request, response);
        }

        public void handleTaskChangeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
            Long taskId = Long.parseLong(request.getParameter("id"));
            Task task = taskService.findById(taskId).orElseThrow(() -> new IllegalArgumentException("Task not found"));

            // Check if there's already a task change request
            Optional<TaskChangeRequest> taskChangeRequest1 = taskChangeRequestService.findByTaskId(taskId).stream().findFirst();
            if (taskChangeRequest1.isPresent()) {
                request.setAttribute("message", "There is already a request for this task!");
                response.sendRedirect("task?action=list");
                return;
            }

            // Check if the user has enough jetons
            User user = (User) request.getSession().getAttribute("user");
            if (user.getJeton().getChangeJeton() > 0) {
                TaskChangeRequest taskChangeRequest = new TaskChangeRequest(task, user, LocalDateTime.now());
                taskChangeRequestService.create(taskChangeRequest);
                response.sendRedirect("task?action=list");
            }
        }


        public void filterTasksByStatus(List<Task> tasks , HttpServletRequest request) {
            List<Task> tasksInProcess = tasks.stream().filter(task -> task.getTaskStatus() == TaskStatus.IN_PROGRESS).collect(Collectors.toList());
            List<Task> tasksCompleted = tasks.stream().filter(task -> task.getTaskStatus() == TaskStatus.COMPLETED).collect(Collectors.toList());
            List<Task> tasksPending = tasks.stream().filter(task -> task.getTaskStatus() == TaskStatus.NOT_STARTED).collect(Collectors.toList());
            request.setAttribute("tasksInProcess", tasksInProcess);
            request.setAttribute("tasksCompleted", tasksCompleted);
            request.setAttribute("tasksPending", tasksPending);
        }


        public Task getAllAttributes(HttpServletRequest request) {
            if (request.getParameter("action").equals("update")) {
                Long id = Long.parseLong(request.getParameter("id"));
                Task task = taskService.findById(id).orElseThrow(() -> new IllegalArgumentException("Task not found"));
                task.setTitle(request.getParameter("title"));
                task.setDescription(request.getParameter("description"));
                task.setDeadline(LocalDateTime.parse(request.getParameter("deadline")));
                task.setTaskStatus(TaskStatus.valueOf(request.getParameter("status")));
                String[] tagNames = request.getParameterValues("tagName");
                List<Tag> tagList = tagService.findAll().stream().filter(tag -> Arrays.asList(tagNames).contains(tag.getName())).collect(Collectors.toList());
                task.setTags(tagList);
                return task;
            }
            User logedUser = (User) request.getSession().getAttribute("user");
            User assignedTo;
            if (logedUser.getUserType() == UserType.USER) {
                assignedTo = logedUser;
            }else {
                Long userId = Long.parseLong(request.getParameter("userId"));
                assignedTo = userService.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
            }
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            LocalDateTime deadline = LocalDateTime.parse(request.getParameter("deadline"));
            TaskStatus status = TaskStatus.valueOf(request.getParameter("status"));
            String[] tagNames = request.getParameterValues("tagName");
            List<Tag> tagList = tagNames != null ? Arrays.stream(tagNames).map(name -> tagService.findByName(name).orElse(null)).collect(Collectors.toList()) : Collections.emptyList();
            return new Task(title, description, deadline, status, assignedTo, logedUser, tagList);
        }
    }
