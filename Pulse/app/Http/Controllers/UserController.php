<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\LoginUserRequest;
use App\Http\Requests\User\StoreUserRequest;
use App\Http\Requests\User\UpdateUserRequest;
use App\Http\Resources\Proyect\ProyectCollection;
use App\Http\Resources\ProyectMember\ProyectMemberCollection;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\User\UserCollection;
use App\Http\Resources\User\UserResource;
use App\Models\Proyect;
use App\Models\ProyectMember;
use App\Models\responseUtils;
use App\Models\User;
use App\Models\Utils;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

use function PHPSTORM_META\type;

class UserController extends Controller
{
    /**
     * Display all of users.
     */
    public function index(Request $request)
    {
        try {
            $users = null;

            //Search username param
            if ($request->query("username")) {
                $users = User::searchByUsername($request->query("username"));
            } else if ($request->query("email")) {
                $users = User::searchByEmail($request->query("email"));
            } else {
                $users = User::getAll();
            }

            return responseUtils::successful(new UserCollection($users));
        } catch (Exception $err) {
            responseUtils::serverError("Error getting users", $err);
        }
    }

    /**
     * Search user with the username y email.
     */
    public function searchUser(Request $request)
    {
        try {
            //Its necessary to send "info" param
            if (!$request->query("info")) {
                return responseUtils::invalidParams("Missing info parameter");
            }

            $users = User::search($request->query("info"));

            return responseUtils::successful(new UserCollection($users));
        } catch (Exception $err) {
            return responseUtils::serverError("Error searching user with username/email, UserController", $err);
        }
    }

    /**
     * Display the specified user.
     */
    public function show(Request $request, $id)
    {
        try {
            $user = null;

            if (!$id) {
                $user = $request["user"];
            } else {
                $user = User::getById($id);
            }

            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            return responseUtils::successful(new UserResource($user));
        } catch (Exception $err) {
            responseUtils::serverError("Error getting user", $err);
        }
    }

    /**
     * Login the user, making a new token.
     */
    public function login(LoginUserRequest $request)
    {
        try {
            $userLogin = new User();
            $userLogin->setEmail($request->email);
            $userLogin->setPassword($request->password);

            $userToken = $userLogin->login();

            if ($userToken) {
                $tokenCookie = cookie('access_token', $userToken, 60 * 24, '/', null, false, false, false, false);

                return responseUtils::successful(new UserResource($userLogin))->withCookie($tokenCookie);
            } else {
                return responseUtils::invalidParams("Invalid email or password");
            }
        } catch (Exception $err) {
            return responseUtils::serverError("Error login user", $err);
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
                return responseUtils::conflict("The email is already in use");
            }

            $newUser = new User(null, $request->username, $request->email, $request->password, $request->photo ?? null);

            $userToken = $newUser->create();
            $newUser->token = $userToken;

            $tokenCookie = cookie("access_token", $userToken, 60 * 24, null, null, true, true);

            return responseUtils::successful(new UserResource($newUser))->withCookie($tokenCookie);
        } catch (Exception $err) {
            responseUtils::serverError("Error creating user", $err);
        }
    }

    /**
     * Logout the user.
     */
    public function logout(Request $request)
    {
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

            if (!$request->username && !$request->email && !$request->password && !$request->photo) {
                return responseUtils::successful(new UserResource($user));
            }

            if ($request->username)
                $user->setUserName($request->username);
            if ($request->password)
                $user->setPassword($request->password);
            if ($request->photo)
                $user->setPhoto($request->photo);

            //Email dont exist
            if ($request->email) {
                $userWithEmail = User::getByEmail($request->email);

                if (!$userWithEmail) {
                    $user->setEmail($request->email);
                } else {
                    return responseUtils::conflict("The email is already in use");
                }
            }

            $user->saveChanges();

            return responseUtils::successful(new UserResource($user));
        } catch (Exception $err) {
            return responseUtils::serverError("Error updating user", $err);
        }
    }

    /**
     * Get the proyects of user.
     */
    public function getProyects(Request $request)
    {
        try {
            $user = $request["user"];

            $proyects = $user->getProyects();

            return responseUtils::successful(new ProyectCollection($proyects));
        } catch (Exception $err) {
            responseUtils::serverError("Error getting proyects of user", $err);
        }
    }

    /**
     * Get the proyects wich the user is joined
     */
    public function getIncludedProyects(Request $request, $userId)
    {
        try {
            $proyectController = new ProyectController();
            $user = $request["user"];

            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            $proyects = $user->getIncludedProyects();

            //Reutilizing "loadMissing"
            $proyectController->loadMissings($request, $proyects);

            return responseUtils::successful(new ProyectCollection($proyects));
        } catch (Exception $err) {
            responseUtils::serverError("Error getting proyects of user", $err);
        }
    }

    /**
     * Get all tasks of the user
     */
    public function getTasks(Request $request, $userId)
    {
        try {
            $user = $userId > 0 ? User::getById($userId) : $request["user"];

            //User exist
            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            if ($request["user"]->getId() != $user->getId()) {
                return responseUtils::unAuthorized("You can't see the task of this user");
            }

            $tasks = $user->getTasks();

            return responseUtils::successful(new TaskCollection($tasks));
        } catch (Exception $err) {
            return responseUtils::serverError("Error gettings users tasks, UserController", $err);
        }
    }

    /**
     * Upload the photo of the user
     */
    public function uploadPhoto(Request $request)
    {
        try {

            if (!$request->hasFile("photo")) {
                return responseUtils::invalidParams("Missing photo");
            }

            $reqUser = $request["user"];
            $user = $reqUser;

            $uploadedPhoto = $request->file("photo");
            $uploadedPhoto->move(Storage::disk("photos")->path("/" . $user->getId()), "photo." . $uploadedPhoto->getClientOriginalExtension());

            $photoPath = $user->getId() . "/photo." . $uploadedPhoto->getClientOriginalExtension();

            //Update photo path on DB
            $user->setPhoto($photoPath);
            $user->saveChanges();

            return responseUtils::successful(new UserResource($reqUser));
        } catch (Exception $err) {
            return responseUtils::serverError("Error uploading photo, UserController", $err);
        }
    }

    /**
     * Get the photo file of the user
     */
    public function getPhoto(Request $request, $userId)
    {
        try {
            $reqUser = $request["user"];
            $user = $userId ? User::getById($userId) : $reqUser;

            //User exist
            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            $photoExist = $user->getPhoto() ? Storage::disk("photos")->exists($user->getPhoto()) : null;

            if (!$photoExist) {
                return null;
            }

            return responseUtils::file(Storage::disk("photos")->path($user->getPhoto()));
        } catch (Exception $err) {
            return responseUtils::serverError("Error getting user photo, UserController", $err);
        }
    }

    /**
     * Get the pendings proyect join requests of the user
     */
    public function getUserPendingJoin(Request $request)
    {
        try {
            $reqUser = $request["user"];

            $pendingRequests = ProyectMember::getPendingProyectMemberRequestByUserId($reqUser->getId());

            $this->loadMissings($request, $pendingRequests);

            return responseUtils::successful(new ProyectMemberCollection($pendingRequests));
        } catch (Exception $err) {
            return responseUtils::serverError("Error getting pending join request of the user, UserController", $err);
        }
    }

    public function isLogged(Request $request) {
        try {
            return responseUtils::successful(new UserResource($request["user"]));

        } catch (Exception $err) {
            return responseUtils::serverError("Error checking if logged, UserController", $err);
        }
    }

    public function loadMissings(Request $request, &$users = [])
    {
        if (Utils::parseBool($request->query("proyect"))) { //Only when "$users" is a collection of ProyectMember
            foreach ($users as $user) {
                if ($user::class != ProyectMember::class)
                    continue;

                //Load proyect
                $user->loadProyect();

                //Load owner
                if (Utils::parseBool($request->query("owner"))) {
                    $user->getProyect()->loadOwner();
                }
            }
        }
    }
}
