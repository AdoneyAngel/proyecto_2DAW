<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Proyect extends Model
{
    private $id;
    private $title;
    private $ownerId;
    private $date;

    public function __construct($id = null, $title = "", $ownerId = null, $date = "") {
        $this->id = $id;
        $this->title = $title;
        $this->ownerId = $ownerId;
        $this->date = $date;
    }

    //Getters & setters
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->id = $id;
        return true;
    }
    public function getTitle(){
        return $this->title;
    }
    public function setTitle(string $title) {
        $this->title = $title;
        return true;
    }
    public function getOwnerId() {
        return $this->ownerId;
    }
    public function setOwnerId($ownerId) {
        $this->ownerId = $ownerId;
        return true;
    }
    public function getDate() {
        return $this->date;
    }
    public function setDate(string $date) {
        $this->date = $date;
        return true;
    }

    //Methods

    public function create() {
        if (!$this->title || !strlen($this->title)) {
            return false;
        }
        if (!$this->ownerId || !strlen($this->ownerId)) {
            return false;
        }

        $createdProyectDb = DB::select("CALL proyects_insert(?,?)", [$this->title, $this->ownerId]);

        if ($createdProyectDb) {
            $proyect = new Proyect(
                $createdProyectDb[0]->id,
                $createdProyectDb[0]->title,
                $createdProyectDb[0]->owner_id,
                $createdProyectDb[0]->date
            );

            $this->id = $createdProyectDb[0]->id;
            $this->date = $createdProyectDb[0]->date;

            return $proyect;

        } else {
            return null;
        }
    }

    public function delete()  {
    }

    public function saveChanges() { //Update method
        if (!$this->id) return false;
        if (!$this->title || !strlen($this->title)) return false;
        if (!$this->ownerId) return false;

        $updatedProyectDb = DB::select("CALL proyects_update(?,?,?)", [$this->id, $this->title, $this->ownerId]);

        if (count($updatedProyectDb)) {
            return self::class;

        } else {
            return null;
        }
    }

    public static function getAll() {
        $proyects = self::selectQuery();

        return $proyects;
    }

    public static function getById($id) {
        $proyects = self::selectQuery(["id" => $id]);

        if ($proyects[0]) {
            return $proyects[0];
        }

        return null;
    }

    public static function getByTitle(string $title) {
        $proyects = self::selectQuery(["title" => $title]);

        return $proyects;
    }

    public static function getByOwnerId($ownerId) {
        $proyects = self::selectQuery(["owner_id" => $ownerId]);

        return $proyects;
    }

    public function getTasks() {
    }

    public function addTask(Task $task) {
    }

    public function getTaskById($id) {
    }

    public function getTaskByTag($tag) {
    }

    public function getTaskByTitle($title) {
    }

    public function getIssues() {
    }

    public function addIssue(Issue $issue) {
    }

    public function getIssueById($id) {
    }

    public function getIssueByTitle($title) {
    }

    public function getIssueByTag($tag) {
    }

    public function getOwner() {
        if (!$this->ownerId) {
            return null;
        }

        $owner = User::getById($this->ownerId);

        if ($owner) {
            return $owner;

        } else {
            return null;
        }
    }

    public function getMembers() {
        if (!$this->id) return null;

        $membersDb = DB::select("CALL users_of_proyect_id(?)", [$this->id]);

        $members = array();

        foreach ($membersDb as $member) {
            $members[] = new ProyectMember(
                $member->id,
                $member->username,
                $member->email,
                $member->password,
                $member->photo,
                $member->registred,
                $member->status,
                $member->effective_time,
                $member->proyect_id,
            );
        }

        return $members;
    }

    public function addMember(ProyectMember $member) {
    }

    public function getMemberById($id) {
    }

    public function getMemberByEmail(string $email) {
    }

    public function getTasksHistory() {
    }

    public function getMembersHistory() {
    }

    public function isMember($userId) {
        if (!$this->id) return false;

        $members = $this->getMembers();

        $exist = false;

        foreach ($members as $member) {
            if ($member->getId() == $userId) {
                $exist = true;
                break;
            }
        }

        return $exist;
    }

    private static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $proyectsDb = DB::select($queryString, $queryValues);

        $proyects = array();

        foreach ($proyectsDb as $actualProyect) {
            $proyects[] = new Proyect($actualProyect->id, $actualProyect->title, $actualProyect->owner_id, $actualProyect->date);
        }

        return $proyects;
    }
}
