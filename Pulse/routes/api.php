<?php

use App\Http\Controllers\ProyectController;
use App\Http\Controllers\TaskController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\userTokenAuthMiddleware;
use Illuminate\Support\Facades\Route;

Route::group(["prefix" => "v1", "middleware" => userTokenAuthMiddleware::class], function () {
    Route::apiResource("/users", UserController::class);
    Route::put("/users", [UserController::class, "update"]);
    Route::get("/users/{id}/proyects", [UserController::class, "getProyects"]);
    Route::get("/users/{id}/includedProyects", [UserController::class, "getIncludedProyects"]);
    Route::get("/users/{id}/tasks", [UserController::class, "getTasks"]);

    Route::apiResource("/proyects", ProyectController::class);
    Route::get("/proyects/{id}/members", [ProyectController::class, "getMembers"]);
    Route::post("/proyects/{id}/members", [ProyectController::class, "addMember"]);
    Route::get("/proyects/{id}/tasks", [ProyectController::class, "getTasks"]);

    Route::apiResource("/tasks", TaskController::class);
    Route::post("/tasks/{id}/users", [TaskController::class, "addUser"]);
    Route::get("/tasks/{id}/users", [TaskController::class, "getUsers"]);
});

Route::post("/login", [UserController::class, "login"])->name("login");
Route::post("/signup", [UserController::class, "signup"])->name("signup");
Route::get("/logout", [UserController::class, "logout"])->name("logout");
