<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\loginCheckEmailRequest;
use App\Http\Requests\User\LoginUserRequest;
use App\Http\Requests\User\SignupUserRequest;
use App\Http\Requests\User\StoreUserRequest;
use App\Http\Requests\User\SyncGoogleAccountRequest;
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
use Google\Client;
use Google\Auth\OAuth2;

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

            //Check if the email exist and have Google Account
            $userWithEmail = User::getByEmail($request->email);

            if (!$userWithEmail) {
                return responseUtils::notFound("User account not found");
            }

            //Check Google Account, if the user have, he must use it
            $userWithEmail->loadGoogleId();

            if ($userWithEmail->getGoogleId()) {
                return responseUtils::invalidParams("The user must login with Google Account");
            }

            //Continue with normal login
            $userLogin->setEmail($request->email);
            $userLogin->setPassword($request->password);

            $userToken = $userLogin->login();

            if ($userToken) {
                $tokenCookie = $this->genSessionCookie($userToken);

                return responseUtils::successful(new UserResource($userLogin))->withCookie($tokenCookie);
            } else {
                return responseUtils::invalidParams("Invalid email or password");
            }
        } catch (Exception $err) {
            return responseUtils::serverError("Error login user", $err);
        }
    }

    /**
     * Check if the user email is valid and exist for the login.
     */
    public function loginCheckEmail(loginCheckEmailRequest $request) {
        try {
            $userWithEmail = User::getByEmail($request->email);

            //Check if the email exist
            if (!$userWithEmail) {
                return responseUtils::notFound("Email not registered");
            }

            //Check if the email have Google Account
            $userWithEmail->loadGoogleId();

            $googleId = $userWithEmail->getGoogleId();

            if ($googleId) {
                return responseUtils::successful(["googleAccount" => true]);

            } else {
                return responseUtils::successful(["googleAccount" => false]);
            }


        } catch (Exception $err) {
            return responseUtils::serverError("Error checking if the email is valid and exist", $err);
        }
    }

    /**
     * Login with Google Account.
     */
    public function googleLogin(SyncGoogleAccountRequest $request) {
        try {
            $token = $request->token;

            //Validate google token
            $validToken = $this->validateGoogleToken($token);

            if (!$validToken) {
                return responseUtils::invalidParams("Invalid google account");
            }

            //Check if the user with this Google ID exist

            $googleId = $validToken["sub"];
            $userWithGoogleId = User::getByGoogleId($googleId);

            if ($userWithGoogleId) {
                $userToken = $userWithGoogleId->genToken();

                $tokenCookie = $this->genSessionCookie($userToken);

                return responseUtils::successful(new UserResource($userWithGoogleId))->withCookie($tokenCookie);

            } else {
                return responseUtils::notFound("This Google Account is not registered");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error login with google account", $err);
        }
    }

    /**
     * Register a new user.
     */
    public function signup(SignupUserRequest $request)
    {
        try {
            if (!$request->password && !$request->googleToken) {
                return responseUtils::invalidParams("Missing password or Google credentials");
            }

            $newUser = null;

            //Validate if email exist
            $userWithEmail = User::getByEmail($request->email);

            if ($userWithEmail) {
                return responseUtils::conflict("The email is already in use");
            }

            if ($request->password) {
                $newUser = new User(null, $request->username, $request->email, $request->password, $request->photo ?? null);

            } else if ($request->googleToken) {
                $newUser = new User(null, $request->username, $request->email, null, $request->photo ?? null);

                $validGoogleToken = $this->validateGoogleToken($request->googleToken);

                if ($validGoogleToken) {
                    $newUser->setGoogleId($validGoogleToken["sub"]);

                } else {
                    return responseUtils::invalidParams("Invalid Google Account");
                }

            }

            $userToken = $newUser->create();
            $newUser->token = $userToken;

            $tokenCookie = $this->genSessionCookie($userToken);

            return responseUtils::successful(new UserResource($newUser))->withCookie($tokenCookie);
        } catch (Exception $err) {
            responseUtils::serverError("Error creating user", $err);
        }
    }

    private function validateGoogleToken(string $credential) {
        //Validate google token
        $googleClient = new Client();
        $googleClient->setAuthConfig(Storage::disk("googleAuth")->path("client_secret.json"));
        $googleClient->setAccessType("offline");

        $googleClient->setClientId(env("GOOGLE_CLIENT_ID"));

        $validToken = $googleClient->verifyIdToken($credential);

        return $validToken;
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

    private function genSessionCookie(string $userToken) {
        try {
            $tokenCookie = cookie("access_token", $userToken, 60 * 24, null, null, true, true);

            return $tokenCookie;

        } catch (Exception $err) {
            throw $err;
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request)
    {
        try {
            $user = $request["user"];
            $changes = false;

            if (!$request->username && !$request->email && !$request->photo) {
                return responseUtils::successful(new UserResource($user));
            }

            if ($request->username && $user->getUserName() != $request->username) {
                $user->setUserName($request->username);
                $changes = true;
            }

            //Email dont exist
            if ($request->email && $user->getEmail() != $request->email) {
                $userWithEmail = User::getByEmail($request->email);

                if (!$userWithEmail) {
                    $user->setEmail($request->email);
                    $changes = true;

                } else {
                    return responseUtils::conflict("The email is already in use");
                }
            }

            if ($changes) {//If there are not changes, dont save
                $user->saveChanges();
            }

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

    /**
     * Remove the google account from the current user
     */
    public function removeGoogleAccount(Request $request) {
        try {
            $reqUser = $request["user"];

            //The user must have a password
            if (!$reqUser->getPassword() || !strlen($reqUser->getPassword())) {
                return responseUtils::invalidParams("You can't unsync your google account if you don't set a password");
            }

            $reqUser->removeGoogleAccount();

            return responseUtils::successful(true);

        } catch (Exception $err) {
            return responseUtils::serverError("Error removing google account", $err);
        }
    }

    /**
     * Validate and Sync google account to the current user
     */
    public function syncGoogleAccount(SyncGoogleAccountRequest $request) {
        try {
            $reqUser = $request["user"];
            $token = $request->token;

            //Validate if the have a google account
            $haveGoogleId = $reqUser->loadGoogleId();

            if ($haveGoogleId) {
                return responseUtils::conflict("You already have a google account synchronized");
            }

            //Validate google token

            $validToken = $this->validateGoogleToken($token);

            if (!$validToken) {
                return responseUtils::invalidParams("Invalid google account");
            }

            $googleId = $validToken["sub"];

            //Validate if the google account is already signed with another user
            $userWithGoogleId = User::getByGoogleId($googleId);

            if ($userWithGoogleId) {
                return responseUtils::conflict("This google account is already signed with another user");
            }

            //Add google account

            $addedAccount = $reqUser->addGoogleAccount($googleId);

            if ($addedAccount) {
                return responseUtils::successful(["email" => $googleId]);

            } else {
                return responseUtils::serverError("Something gone wrong");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error synchronizing google account", $err, "Error synchronizing google account");
        }
    }

    /**
     * Check if the user have a google account
     */
    public function checkGoogleAccount(Request $request) {
        try {
            $reqUser = $request["user"];

            $reqUser->loadGoogleId();

            if ($reqUser->getGoogleId()) {
                return responseUtils::successful(true);

            }else {
                return responseUtils::successful(false);
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error checking if the user have google account", $err);
        }
    }

    /**
     * Check if the user have a password
     */
    public function checkUserPassword(Request $request) {
        try {
            $reqUser = $request["user"];

            return responseUtils::successful($reqUser->getPassword() && strlen($reqUser->getPassword()));

        } catch (Exception $err) {
            return responseUtils::serverError("Error checking if the user have password", $err);
        }
    }

    /**
     * Add password to user, only if the user don't have
     */
    public function addUserPassword(Request $request) {
        try {
            $reqUser = $request["user"];

            //Check if the user have password
            if ($reqUser->getPassword() || strlen($reqUser->getPassword())) {
                return responseUtils::invalidParams("You already have password");
            }

            if (!$request->password || !strlen($request->password)) {
                return responseUtils::invalidParams("Missing password");
            }

            $updatedUser = $reqUser->addPassword($request->password);

            if ($updatedUser) {
                return responseUtils::successful(true);

            } else {
                return responseUtils::serverError("Can't add the password");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error adding user password", $err);
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
