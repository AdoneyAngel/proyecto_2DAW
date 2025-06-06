<?php

use App\Http\Controllers\ProyectController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\userTokenAuthMiddleware;
use Illuminate\Support\Facades\Route;


Route::group(["prefix" => "v1", "middleware" => userTokenAuthMiddleware::class], function () {
    Route::get("/isLogged", [UserController::class, "isLogged"]);

    //----users
    Route::apiResource("/users", UserController::class);
    Route::get("/searchUser", [UserController::class, "searchUser"]);
    Route::put("/users", [UserController::class, "update"]);
    Route::get("/users/{id}/proyects", [UserController::class, "getProyects"]);
    Route::get("/users/{id}/includedProyects", [UserController::class, "getIncludedProyects"]);
    Route::get("/users/{id}/tasks", [UserController::class, "getTasks"]);
    Route::get("/users/{id}/photo", [UserController::class, "getPhoto"]);
    Route::post("/users/{id}/photo", [UserController::class, "uploadPhoto"]);
    Route::get("/users/{id}/pendingRequests", [UserController::class, "getUserPendingJoin"]);
    Route::post("/googleAccount", [UserController::class, "syncGoogleAccount"]);
    Route::get("/googleAccount", [UserController::class, "getGoogleAccount"]);
    Route::post("/checkGoogleAccount", [UserController::class, "checkGoogleAccount"]);
    Route::delete("/googleAccount", [UserController::class, "removeGoogleAccount"]);
    Route::get("/checkPassword", [UserController::class, "checkUserPassword"]);
    Route::post("/addPassword", [UserController::class, "addUserPassword"]);

    //----Proyects
    Route::apiResource("/proyects", ProyectController::class);
    Route::get("/proyects/{id}/members/{memberId}/type", [ProyectController::class, "getProyectMemberType"]);
    Route::get("/proyects/{id}/members", [ProyectController::class, "getMembers"]);
    Route::post("/proyects/{id}/members", [ProyectController::class, "addMember"]);
    Route::get("/proyects/{id}/members/{memberId}", [ProyectController::class, "showMember"]);
    Route::put("/proyects/{id}/members/{memberId}", [ProyectController::class, "updateMember"]);
    Route::delete("/proyects/{id}/members/{memberId}", [ProyectController::class, "removeMember"]);
    Route::get("/proyects/{id}/tasks", [ProyectController::class, "getTasks"]);
    Route::get("/proyects/{id}/membersHistory", [ProyectController::class, "getMembersHistory"]);
    Route::get("/proyects/{id}/tasksHistory", [ProyectController::class, "getTasksHistory"]);
    Route::get("/proyects/{id}/pendingRequests", [ProyectController::class, "getUserPendingJoinOfProyect"]);
    Route::put("/acceptRequest/{proyectId}", [ProyectController::class, "acceptProyectRequest"]);
    Route::put("/rejectRequest/{proyectId}", [ProyectController::class, "rejectProyectRequest"]);
    Route::get("/proyects/{id}/unassignedTasks", [ProyectController::class, "getUnassignedTasks"]);
    Route::get("/proyects/{id}/tags", [ProyectController::class, "getTags"]);
    Route::get("/proyects/{id}/issues", [ProyectController::class, "getIssues"]);

    //----Tasks
    Route::apiResource("/tasks", TaskController::class);
    Route::post("/tasks/{id}/users", [TaskController::class, "addUser"]);
    Route::delete("/tasks/{id}/users", [TaskController::class, "removeUser"]);
    Route::get("/tasks/{id}/users", [TaskController::class, "getUsers"]);
    Route::put("/tasks/{id}/nextStatus", [TaskController::class, "nextStatus"]);
    Route::get("/tasks/{id}/users/{userId}/status", [TaskController::class, "getUserStatus"]);
    Route::post("/tasks/{id}/comments", [TaskController::class, "addComment"]);
    Route::get("/tasks/{id}/comments", [TaskController::class, "getComments"]);
    Route::put("/tasks/{id}/users/{userId}", [TaskController::class, "changeUserTaskStatus"]);
    Route::get("/tasks/{id}/history", [TaskController::class, "getTaskHistory"]);

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
Route::group(["prefix" => "v1"], function() {
    Route::post("loginEmail", [UserController::class, "loginCheckEmail"]);
    Route::post("googleLogin", [UserController::class, "googleLogin"])->name("login");
    Route::post("login", [UserController::class, "login"])->name("login");
    Route::post("signup", [UserController::class, "signup"])->name("signup");
    Route::get("logout", [UserController::class, "logout"])->name("logout");
});


