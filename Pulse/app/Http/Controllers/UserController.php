<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\LoginUserRequest;
use App\Http\Requests\User\StoreUserRequest;
use App\Http\Requests\User\UpdateUserRequest;
use App\Http\Resources\Proyect\ProyectCollection;
use App\Http\Resources\User\UserCollection;
use App\Http\Resources\User\UserResource;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * Display all of users.
     */
    public function index()
    {
        try {
            $users = User::getAll();

            return response()->json(new UserCollection($users));

        } catch (\Exception $err) {
            error_log("Error getting users: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Display the specified user.
     */
    public function show($id)
    {
        try {
            if (!$id) {
                return response()->json([
                    "success" => false,
                    "error" => "Missing ID"
                ], 422);
            }

            $user = User::getById($id);

            if (!$user) {
                return response()->json([
                    "success" => false,
                    "error" => "User not found"
                ], 404);
            }

            return response()->json([
                "success" => true,
                "data" => new UserResource($user)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Login the user, making a new token.
     */
    public function login(LoginUserRequest $request) {
        try {
            $userLogin = new User();
            $userLogin->setEmail($request->email);
            $userLogin->setPassword($request->password);

            $userToken = $userLogin->login();

            if ($userToken) {
                $tokenCookie = cookie("access_token", $userToken, 60*24, null, null, true, true);

                return response()->json([
                    "success" => true,
                    "data" => new UserResource($userLogin),
                    "token" => $userToken
                ])->withCookie($tokenCookie);

            } else {
                return response()->json([
                    "success" => false,
                    "error" => "Invalid email or password"
                ], 401);
            }

        } catch (\Exception $err) {
            error_log("Error login user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Register a new user.
     */
    public function signup(StoreUserRequest $request)
    {
        try {
            //Validate if email exist
            $userWithEmail = User::getByEmail($request->email);

            if (count($userWithEmail)) {
                return response("Duplicated email", 409);
            }

            $newUser = new User(null, $request->username, $request->email, $request->password, $request->photo ?? null);

            $userToken = $newUser->create();
            $newUser->token = $userToken;

            $tokenCookie = cookie("access_token", $userToken, 60*24, null, null, true, true);

            return response()->json([
                "success" => true,
                "data" => new UserResource($newUser),
                "token" => $userToken
            ], 201)->withCookie($tokenCookie);

        } catch (\Exception $err) {
            error_log("Error creating user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Logout the user.
     */
    public function logout(Request $request) {
        return response()->json([
            "success" => true
        ])->withoutCookie("access_token");
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request)
    {
        try {
            $user = $request["user"];

            if (!$request->username && $request->email && $request->password && $request->photo) {
                return response()->json([
                    "success" => true,
                    "data" => new UserResource($user)
                ], 200);
            }

            if ($request->username) $user->setUserName($request->username);
            if ($request->email) $user->setEmail($request->email);
            if ($request->password) $user->setPassword($request->password);
            if ($request->photo) $user->setPhoto($request->photo);

            $user->saveChanges();

            return response()->json([
                "success" => true,
                "data" => new UserResource($user)
            ], 200);

        } catch (\Exception $err) {
            error_log("Error updating user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Get the proyects of user. (if ID is undefined or $id<1, it will use the id of the user who make the request)
     */
    public function getProyects(Request $request, $userId) {
        try {
            $user = $request["user"] ?? $userId;

            if (!$user) {
                return response()->json([
                    "success" => false,
                    "error" => "User not found"
                ], 404);
            }

            $proyects = $user->getProyects();

            return response()->json([
                "success" => true,
                "data" => new ProyectCollection($proyects)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting proyects of user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    public function getIncludedProyects(Request $request, $userId) {
        try {
            $user = $request["user"] ?? $userId;

            if (!$user) {
                return response()->json([
                    "success" => false,
                    "error" => "User not found"
                ], 404);
            }

            $proyects = $user->getIncludedProyects();

            return response()->json([
                "success" => true,
                "data" => new ProyectCollection($proyects)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting proyects of user: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }
}
