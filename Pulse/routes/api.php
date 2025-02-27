<?php

use App\Http\Controllers\ProyectController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\userTokenAuthMiddleware;
use Illuminate\Support\Facades\Route;

Route::group(["prefix" => "v1", "middleware" => userTokenAuthMiddleware::class], function () {
    Route::apiResource("/users", UserController::class);
    Route::put("/users", [UserController::class, "update"]);

    Route::apiResource("/proyects", ProyectController::class);
});

Route::post("/login", [UserController::class, "login"])->name("login");
Route::post("/signup", [UserController::class, "signup"])->name("signup");
Route::get("/logout", [UserController::class, "logout"])->name("logout");
