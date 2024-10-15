    package org.DevSync.Servlet;

    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import org.DevSync.Domain.*;
    import org.DevSync.Domain.Enum.TaskStatus;
    import org.DevSync.Domain.Enum.UserType;
    import org.DevSync.Service.Implementation.*;
    import org.DevSync.Service.Interface.*;

    import java.io.IOException;
    import java.time.LocalDateTime;
    import java.util.Arrays;
    import java.util.Collections;
    import java.util.List;
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
            this.userService = new UserServiceImpl();
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

        public void delete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            User logedUser = (User) request.getSession().getAttribute("user");
            Long id = Long.parseLong(request.getParameter("id"));

            if (logedUser.getUserType() == UserType.MANAGER) {
                taskService.delete(id);

                if (logedUser.getUserType() != UserType.MANAGER) {
                    Jeton jeton = logedUser.getJeton();
                    jeton.setDeleteJeton(jeton.getDeleteJeton() - 1);
                    jetonService.update(jeton);
                }

                request.setAttribute("message", "Task deleted successfully!");
                response.sendRedirect("task?action=list");
            } else {
                request.setAttribute("error", "You do not have permission to delete this task.");
                request.getRequestDispatcher("task.jsp").forward(request, response);
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
            User user = (User) request.getSession().getAttribute("user");
            if (user.getJeton().getChangeJeton() > 0){
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
