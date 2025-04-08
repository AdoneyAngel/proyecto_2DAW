<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Date;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class User extends Model
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory;

    protected $id;
    protected $username;
    protected $email;
    protected $password;
    protected $photo;
    protected $registred;
    private $googleId;

    public function __construct($id = null, $username = "", $email = "", $password = "", $photo = null, $registred = null) {
        $this->id = $id;
        $this->username = $username;
        $this->password = $password;
        $this->email = $email;
        $this->photo = $photo;
        $this->registred = $registred;
    }

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'username',
        'email',
        'password',
        'photo',
        'registred'
    ];

    //Getters & setters
    public function getId() {
        return $this->id;
    }
    public function setId($newId) {
        $this->id = $newId;

        return true;
    }
    public function getUserName() {
        return $this->username;
    }
    public function setUserName(string $newUserName) {
        $this->username = $newUserName;

        return true;
    }
    public function getEmail() {
        return $this->email;
    }
    public function setEmail(string $newEmail) {
        $this->email = $newEmail;

        return true;
    }
    public function getPassword() {
        return $this->password;
    }
    public function setPassword(string $unHashedPassword) {
        $this->password = $unHashedPassword;

        return true;
    }
    public function getPhoto() {
        return $this->photo;
    }
    public function setPhoto(string $newPhotoPath) {
        $this->photo = $newPhotoPath;

        return true;
    }
    public function getRegistred() {
        return $this->registred;
    }
    public function setRegistred(string $newRegistredDate) {
        $this->registred = $newRegistredDate;

        return true;
    }
    public function getGoogleId() {
        return $this->googleId;
    }
    public function setGoogleId(string $googleId) {
        $this->googleId = $googleId;
    }

    //Methods
    public function login() {
        if (!$this->email || !strlen($this->email)) {
            return false;
        }
        if (!$this->password || !strlen($this->password)) {
            return false;
        }

        //Search the user with the email
        $userWithMail = $this->getByEmail($this->email);

        if (!$userWithMail) {
            return false;

        }

        //Compare the current password with the hashed password
        if (password_verify($this->password, $userWithMail->password)) {
            $this->id = $userWithMail->id;
            $token = $this->genToken();
            return $token;
        }

        return false;

    }

    public function create(): string|null {
        //----validate attrs
        //username
        if (!$this->username || !strlen($this->username)) {
            throw new \Exception("Missing username");
        }
        //email
        if (!$this->email || !strlen($this->email)) {
            throw new \Exception("Missing email");
        }
        //password
        if ((!$this->password || !strlen($this->password)) && (!$this->googleId || !strlen($this->googleId))) {
            throw new \Exception("Missing password");
        }

        //Create user with email-password or email-google account
        $newUserDb = null;

        if ($this->password) {
            //----has password
            $hashedPassword = password_hash($this->password, PASSWORD_DEFAULT);

            $newUserDb = DB::select("CALL users_insert(?,?,?,?)", [$this->username, $this->email, $hashedPassword, $this->photo]);

        } else if ($this->googleId) {
            $newUserDb = DB::select("CALL users_insert_with_google(?,?,?,?)", [$this->username, $this->email, $this->googleId, $this->photo]);

        }

        if (count($newUserDb)) {
            $this->id = $newUserDb[0]->id;
            $this->registred = $newUserDb[0]->registred;

            $newUser = new User(
                $newUserDb[0]->id,
                $newUserDb[0]->username,
                $newUserDb[0]->email,
                null,
                $newUserDb[0]->photo,
                $newUserDb[0]->registred
            );

            //Generate token
            $token = $this->genToken();

            return $token;

        } else {
            return null;
        }

    }

    public function saveChanges() {//'update' method
        //----validate attrs
        //id
        if (!$this->id) {
            throw new \Exception("Missing id");
        }
        //username
        if (!$this->username || !strlen($this->username)) {
            throw new \Exception("Missing username");
        }
        //email
        if (!$this->email || !strlen($this->email)) {
            throw new \Exception("Missing email");
        }
        //password
        if (!$this->password || !strlen($this->password)) {
            throw new \Exception("Missing password");
        }

        $updatedUser = DB::select("CALL users_update(?,?,?,?,?)", [$this->id, $this->username, $this->email, $this->password, $this->photo]);

        if ($updatedUser[0]) {
            $this->userName = $updatedUser[0]->username;
            $this->email = $updatedUser[0]->email;
            $this->password = $updatedUser[0]->password;
            $this->photo = $updatedUser[0]->photo;

            return new User(
                $updatedUser[0]->id,
                $updatedUser[0]->username,
                $updatedUser[0]->email,
                $updatedUser[0]->password,
                $updatedUser[0]->photo,
                $updatedUser[0]->registred,
            );

        } else {
            return false;
        }

    }

    public static function getAll(): array {
        $users = self::selectQuery();

        return $users;

    }

    public static function getById($id){
        $users = self::selectQuery(["id" => $id]);

        if (isset($users[0])) {
            return $users[0];
        }

        return null;
    }

    public static function getByEmail(string $email) {
        $userDb = self::selectQuery(["email" => $email]);

        if (count($userDb)) {
            return $userDb[0];

        } else {
            return null;
        }
    }

    public static function getByGoogleId(string $googleId) {
        $userDb = self::selectQuery(["googleId" => $googleId]);

        if (count($userDb)) {
            return new User(
                $userDb[0]->id,
                $userDb[0]->username,
                $userDb[0]->email,
                $userDb[0]->password,
                $userDb[0]->photo,
                $userDb[0]->registred);

        } else {
            return null;
        }
    }

    public function getProyects() {
        if (!$this->id) {
            return [];
        }

        $proyects = Proyect::getByOwnerId($this->id);

        return $proyects;

    }

    public function getTasks() {
        if (!$this->id) return null;

        $tasks = Task::getByUserId($this->id);

        return $tasks;
    }

    public function getIncludedProyects() {
        if (!$this->id) return null;

        $proyectsOfmember = DB::select("CALL proyects_of_user_id(?)", [$this->id]);

        if (count($proyectsOfmember)) {
            $proyects = [];

            foreach ($proyectsOfmember as $proyect) {
                $proyects[] = new Proyect(
                    $proyect->id,
                    $proyect->title,
                    $proyect->owner_id,
                    $proyect->date
                );
            }

            return $proyects;

        } else {
            return [];
        }
    }

    public function getStatusInTask($idTask) {

    }

    public static function searchByUsername(string $username) {
        $usersDb = DB::select("CALL users_search_username(?)", [$username]);

        $users = [];

        if (count($usersDb)) {
            foreach ($usersDb as $user) {
                $users[] = new User(
                    $user->id,
                    $user->username,
                    $user->email,
                    $user->password,
                    $user->photo,
                    $user->registred
                );
            }
        }

        return $users;
    }

    public static function searchByEmail(string $email) {
        $usersDb = DB::select("CALL users_search_email(?)", [$email]);

        $users = [];

        if (count($usersDb)) {
            foreach ($usersDb as $user) {
                $users[] = new User(
                    $user->id,
                    $user->username,
                    $user->email,
                    $user->password,
                    $user->photo,
                    $user->registred
                );
            }
        }

        return $users;
    }

    public static function search(string $info) {
        $usersDb = DB::select("CALL users_search(?)", [$info]);

        $users = [];

        if (count($usersDb)) {
            foreach ($usersDb as $user) {
                $users[] = new User(
                    $user->id,
                    $user->username,
                    $user->email,
                    $user->password,
                    $user->photo,
                    $user->registred
                );
            }
        }

        return $users;
    }

    public function loadGoogleId() {
        if (!$this->id) return null;

        $googleIdDb = DB::select("SELECT googleId FROM users WHERE id = ?", [$this->id]);

        if ($googleIdDb[0]->googleId) {
            $this->googleId = $googleIdDb[0]->googleId;
            return $this->googleId;

        } else {
            return null;
        }
    }

    public function addGoogleAccount($googleId) {
        if (!$this->id) return null;

        $dbAddAccount = DB::statement("CALL add_google_account(?,?)", [$this->id, $googleId]);

        return true;
    }

    public function removeGoogleAccount() {
        if (!$this->id) return null;

        $deletedDb = DB::statement("CALL remove_google_account(?)", [$this->id]);

        return true;
    }

    public function genToken() {
        $validToken = false;
        $newToken = "";

        //Generate new token
        while (!$validToken) {
            $validToken = true;

            $newToken = password_hash($this->password, PASSWORD_DEFAULT);

            //Check if token exist
            if ($this->tokenExist($newToken)) {
                $validToken = false;
            }
        }

        //Save token
        $expireDateStr = strtotime("+1 day");
        $expireDate = date("Y-m-d H:i:s", $expireDateStr);
        DB::select("CALL users_tokens_insert(?,?,?)", [$this->id, $newToken, $expireDate]);

        return $newToken;
    }

    public function addPassword(string $password) {
        if (!$this->id) return null;

        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

        $userUpdated = DB::select("CALL user_add_password(?,?)", [$this->id, $hashedPassword]);

        if ($userUpdated) {
            return new User(
                $userUpdated[0]->id,
                $userUpdated[0]->username,
                $userUpdated[0]->email,
                $userUpdated[0]->password,
                $userUpdated[0]->photo,
                $userUpdated[0]->registred,
            );

        } else {
            return null;
        }
    }

    private function tokenExist(string $token) {
        $tokenFound = DB::select("SELECT * FROM users_tokens WHERE token = ?", [$token]);

        if ($tokenFound) {
            return true;

        } else {
            return false;
        }
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM users ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM users WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $usersDb = DB::select($queryString, $queryValues);

        $users = array();

        foreach ($usersDb as $actualUser) {
            $users[] = new User($actualUser->id, $actualUser->username, $actualUser->email, $actualUser->password, $actualUser->photo, $actualUser->registred);
        }

        return $users;
    }
}
