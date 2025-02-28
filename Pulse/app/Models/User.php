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

    //Methods
    public function login() {
        if (!$this->email || ! strlen($this->email)) {
            return false;
        }
        if (!$this->password || ! strlen($this->password)) {
            return false;
        }

        //Search the user with the email
        $userWithMail = $this->getByEmail($this->email);

        if (!count($userWithMail)) {
            return false;

        }

        //Compare the current password with the hashed password
        if (password_verify($this->password, $userWithMail[0]->password)) {
            $this->id = $userWithMail[0]->id;
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
        if (!$this->password || !strlen($this->password)) {
            throw new \Exception("Missing password");
        }

        //----has password
        $hashedPassword = password_hash($this->password, PASSWORD_DEFAULT);

        $newUserDb = DB::select("CALL users_insert(?,?,?,?)", [$this->username, $this->email, $hashedPassword, $this->photo]);

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

    public static function getByEmail(string $email): array {
        $users = self::selectQuery(["email" => $email]);

        return $users;
    }

    public function getProyects() {
        if (!$this->id) {
            return [];
        }

        $proyects = Proyect::getByOwnerId($this->id);

        return $proyects;

    }

    public function getIncludedProyects() {
        if (!$this->id) return null;

        $proyectsOfmember = DB::select("CALL proyects_of_member_id(?)", [$this->id]);

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

    private function genToken() {
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
