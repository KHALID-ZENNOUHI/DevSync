<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>

    <!-- Tailwind CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
<div class="bg-white shadow-md rounded-lg p-8 w-96">
    <h2 class="text-2xl font-bold mb-6 text-center">Login</h2>
    <% String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
        <strong class="font-bold">Error!</strong>
        <span class="block sm:inline"><%= error %></span>
    </div>
    <% } %>
    <form method="post" action="">
        <div class="mb-4">
            <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
            <input type="text" id="email" name="email" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:ring focus:ring-blue-200" placeholder="Enter your email">
        </div>
        <div class="mb-6">
            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
            <input type="password" id="password" name="password" required class="mt-1 block w-full p-2 border border-gray-300 rounded-md focus:ring focus:ring-blue-200" placeholder="Enter your password">
        </div>
        <button type="submit" class="w-full bg-blue-600 text-white p-2 rounded-md hover:bg-blue-700 transition duration-200">Login</button>
    </form>
    <p class="mt-4 text-center text-sm text-gray-600">
        Don't have an account? <a href="#" class="text-blue-600 hover:underline">Sign up</a>
    </p>
</div>
</body>
</html>
