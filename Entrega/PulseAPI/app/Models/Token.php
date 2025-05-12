<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Token extends Model
{
    protected $id;
    protected $token;
    protected $user_id;
    protected $expireDate;

    public function __construct($id = -1, $token = "", $expireDate = "", $user_id) {
        $this->id = $id;
        $this->token = $token;
        $this->expireDate = $expireDate;
        $this->user_id = $user_id;
    }

    //Getters & setters
    public function getId(): int|string {
        return $this->id;
    }
    public function getToken(): string {
        return $this->token;
    }
    public function getUserId(): int {
        return $this->user_id;
    }
    public function setExpireDate(string $date) {
        $this->expireDate = $date;

        return true;
    }

    //Methods
    public static function getAll() {
        $tokens = self::selectQuery();

        return $tokens;
    }

    public static function getByID($id) {
        $tokens = self::selectQuery(["id" => $id]);

        if ($tokens[0]) {
            return $tokens[0];
        }

        return null;
    }

    public static function getByToken(string $token) {
        $tokens = self::selectQuery(["token" => $token]);

        if ($tokens[0]) {
            return $tokens[0];
        }

        return null;
    }

    public function isExpired() {
        if (!$this->expireDate) return true;

        $currentDate = strtotime("now");
        $expireDate = strtotime($this->expireDate);

        if ($currentDate>=$expireDate) return true;

        return false;
    }

    private static function selectQuery(array $whereValues = null): array {
        $queryString = "SELECT * FROM users_tokens ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM users_tokens WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $tokensDb = DB::select($queryString, $queryValues);

        $tokens = array();

        foreach ($tokensDb as $actualToken) {
            $tokens[] = new Token($actualToken->id, $actualToken->token, $actualToken->expire_date, $actualToken->user_id);
        }

        return $tokens;
    }
}
