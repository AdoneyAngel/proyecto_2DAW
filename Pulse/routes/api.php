<?php

use App\Http\Controllers\ProyectController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\userTokenAuthMiddleware;
use App\Models\responseUtils;
use Illuminate\Support\Facades\Route;


Route::group(["prefix" => "v1", "middleware" => userTokenAuthMiddleware::class], function () {
    Route::get("/isLogged", function () {
        return responseUtils::successful(true);
    });

    //----users
    Route::apiResource("/users", UserController::class);
    Route::get("/searchUser", [UserController::class, "searchUser"]);
    Route::put("/users", [UserController::class, "update"]);
    Route::get("/users/{id}/proyects", [UserController::class, "getProyects"]);
    Route::get("/users/{id}/includedProyects", [UserController::class, "getIncludedProyects"]);
    Route::get("/users/{id}/tasks", [UserController::class, "getTasks"]);
    Route::get("/users/{id}/photo", [UserController::class, "getPhoto"]);
    Route::post("/users/{id}/photo", [UserController::class, "uploadPhoto"]);

    //----Proyects
    Route::apiResource("/proyects", ProyectController::class);
    Route::get("/proyects/{id}/members", [ProyectController::class, "getMembers"]);
    Route::post("/proyects/{id}/members", [ProyectController::class, "addMember"]);
    Route::get("/proyects/{id}/tasks", [ProyectController::class, "getTasks"]);
    Route::get("/proyects/{id}/membersHistory", [ProyectController::class, "getMembersHistory"]);
    Route::get("/proyects/{id}/tasksHistory", [ProyectController::class, "getTasksHistory"]);

    //----Tasks
    Route::apiResource("/tasks", TaskController::class);
    Route::post("/tasks/{id}/users", [TaskController::class, "addUser"]);
    Route::get("/tasks/{id}/users", [TaskController::class, "getUsers"]);
    Route::put("/tasks/{id}/nextStatus", [TaskController::class, "nextStatus"]);
    Route::get("/tasks/{id}/users/{userId}/status", [TaskController::class, "getUserStatus"]);
    Route::post("/tasks/{id}/comments", [TaskController::class, "addComment"]);
    Route::get("/tasks/{id}/comments", [TaskController::class, "getComments"]);

    //----Issues
    Route::get("/issues", [TaskController::class, "issueIndex"]);
    Route::post("/issues", [TaskController::class, "issueStore"]);
    Route::put("/issues/{id}", [TaskController::class, "issueUpdate"]);
    Route::get("/issues/{id}", [TaskController::class, "issueShow"]);
    Route::delete("/issues/{id}", [TaskController::class, "issueDestroy"]);
    Route::post("/issues/{id}/users", [TaskController::class, "issueAddUser"]);
    Route::get("/issues/{id}/users", [TaskController::class, "issueGetUsers"]);
    Route::put("/issues/{id}/nextStatus", [TaskController::class, "issueNextStatus"]);
    Route::get("/issues/{id}/users/{userId}/status", [TaskController::class, "issueGetUserStatus"]);
    Route::post("/issues/{id}/comments", [TaskController::class, "issueAddComment"]);
    Route::get("/issues/{id}/comments", [TaskController::class, "issueGetComments"]);
});

//----Sesion
Route::post("/login", [UserController::class, "login"])->name("login");
Route::post("/signup", [UserController::class, "signup"])->name("signup");
Route::get("/logout", [UserController::class, "logout"])->name("logout");

