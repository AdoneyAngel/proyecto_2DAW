<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class MemberHistory extends Model
{
    protected $id;
    protected $action;
    protected $date;
    protected $userId;
    protected $proyectId;
    protected $user;

    public function __construct($id = 0, $action = "", $date = "", $userId = 0, $proyectId = 0, User|null $user = null) {
        $this->id = $id;
        $this->action = $action;
        $this->date = $date;
        $this->userId = $userId;
        $this->proyectId = $proyectId;
        $this->user = $user;
    }

    //Gettes & setters
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->id = $id;
    }
    public function getAction() {
        return $this->action;
    }
    public function setAction($action) {
        $this->action = $action;
    }
    public function getDate() {
        return $this->date;
    }
    public function setDate($date) {
        $this->date = $date;
    }
    public function getUserId() {
        return $this->userId;
    }
    public function setUserId($userId) {
        $this->userId = $userId;
    }
    public function getProyectId() {
        return $this->proyectId;
    }
    public function setProyectId($proyectId) {
        $this->proyectId = $proyectId;
    }
    public function getUser() {
        return $this->user;
    }

    public static function getAll() {
        $history = self::selectQuery();

        return $history;
    }

    public static function getByProyectId($proyectId) {
        $history = [];

        $historyDb = DB::select("CALL proyects_members_history_of_proyect_id(?)", [$proyectId]);

        if (count($historyDb)) {
            foreach($historyDb as $actualHistoryItem) {
                $historyItemUser = new User(
                    $actualHistoryItem->user_id,
                    $actualHistoryItem->username,
                    $actualHistoryItem->email,
                    $actualHistoryItem->password,
                    $actualHistoryItem->photo,
                    $actualHistoryItem->registred
                );

                $history[] = new MemberHistory(
                    $actualHistoryItem->id,
                    $actualHistoryItem->action,
                    $actualHistoryItem->date,
                    $actualHistoryItem->user_id,
                    $actualHistoryItem->proyect_id,
                    $historyItemUser,
                );
            }
        }

        return $history;
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects_members_history ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects_members_history WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $historyDb = DB::select($queryString, $queryValues);

        $history = array();

        foreach ($historyDb as $actualHistoryItem) {

            $history[] = new MemberHistory(
                $actualHistoryItem->id,
                $actualHistoryItem->action,
                $actualHistoryItem->date,
                $actualHistoryItem->user_id,
                $actualHistoryItem->proyect_id);
        }

        return $history;
    }
}
