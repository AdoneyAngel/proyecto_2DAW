<?php

namespace App\Models;

use App\TaskStatusEnum;
use App\TaskTypeEnum;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Task extends Model
{
    protected $id;
    protected $description;
    protected $date;
    protected $time;
    protected $priority;
    protected $tag;
    protected $title;
    protected $statusId;
    protected $proyectId;

    public function __construct($id = -1, $title = "", $description = "", $tag = "", $time = 1, $priority = 0, $proyectId = 0, $statusId = 0, $date = 0, $type = TaskTypeEnum::Task) {
        $this->id = $id;
        $this->title = $title;
        $this->description = $description;
        $this->tag = $tag;
        $this->time = $time;
        $this->proyectId = $proyectId;
        $this->priority = $priority;
        $this->statusId = $statusId;
        $this->date = $date;
        $this->type = $type;
    }

    //Getters & setters
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->id = $id;
        return true;
    }
    public function getTitle() {
        return $this->title;
    }
    public function setTitle($title) {
        $this->title = $title;
        return true;
    }
    public function getDescription() {
        return $this->description;
    }
    public function setDescription($description) {
        $this->description = $description;
        return true;
    }
    public function getTag() {
        return $this->tag;
    }
    public function setTag($tag) {
        $this->tag = $tag;
        return true;
    }
    public function getTime() {
        return $this->time;
    }
    public function setTime($time) {
        $this->time = $time;
        return true;
    }
    public function getPriority() {
        return $this->priority;
    }
    public function setPriority($priority) {
        $this->priority = $priority;
        return true;
    }
    public function getStatusId() {
        return $this->statusId;
    }
    public function setStatusId($statusId) {
        $this->statusId = $statusId;
        return true;
    }
    public function getDate() {
        return $this->date;
    }
    public function setDate($date) {
        $this->date = $date;
        return true;
    }
    public function getProyectId() {
        return $this->proyectId;
    }
    public function setProyectId($proyectId) {
        $this->proyectId = $proyectId;
        return true;
    }
    public function getType() {
        return $this->type;
    }
    public function setType(TaskTypeEnum $type) {
        $this->type = $type;
        return true;
    }

    //Methods
    public static function getAll (){
        $tasks = self::selectQuery();

        return $tasks;
    }

    public static function getById($id) {
        $tasks = self::selectQuery(["id" => $id]);

        if (count($tasks)) {
            return $tasks[0];
        }

        return [];
    }

    public static function getByTitle($title) {
        $tasks = self::selectQuery(["title" => $title]);

        return $tasks;
    }

    public static function getByDescription($description) {
        $tasks = self::selectQuery(["description" => $description]);

        return $tasks;
    }

    public static function getByTag($tag) {
        $tasks = self::selectQuery(["tag" => $tag]);

        return $tasks;
    }

    public static function getByTime($time) {
        $tasks = self::selectQuery(["time" => $time]);

        return $tasks;
    }

    public static function getByPriority($priority) {
        $tasks = self::selectQuery(["priority" => $priority]);

        return $tasks;
    }

    public static function getByStatusId($statusId) {
        $tasks = self::selectQuery(["status" => $statusId]);

        return $tasks;
    }

    public static function getByProyectId($proyectId) {
        $tasks = self::selectQuery(["proyect_id" => $proyectId]);

        return $tasks;
    }

    public function getProyect() {
        if (!$this->proyectId) return null;

        $proyect = Proyect::getById($this->proyectId);

        return $proyect;
    }

    public function getUsers() {
    }

    public function addUser(User $user) {
        if (!$this->id) return null;
        if (!$this->proyectId) return null;
    }

    public function getStatus() {
        if (!$this->statusId) return null;

        $status = new TaskStatus(TaskStatusEnum::cases()[$this->statusId]);

        return $status;
    }

    public function saveChanges() {
    }

    public function create() {
        if (!$this->title || !strlen($this->title)) return null;
        if (!$this->tag || !strlen($this->tag)) return null;
        if (!$this->description || !strlen($this->description)) return null;
        if (!$this->time) return null;
        if ($this->priority < 0) return null;
        if (!$this->proyectId) return null;

        $createdTaskDb = DB::select("CALL proyects_tasks_insert(?,?,?,?,?,?)", [
            $this->title,
            $this->description,
            $this->tag,
            $this->time,
            $this->priority,
            $this->proyectId
        ]);

        if (count($createdTaskDb)) {
            $this->id = $createdTaskDb[0]->id;
            $this->date = $createdTaskDb[0]->date;

            return new Task(
                $createdTaskDb[0]->id,
                $createdTaskDb[0]->title,
                $createdTaskDb[0]->description,
                $createdTaskDb[0]->tag,
                $createdTaskDb[0]->time,
                $createdTaskDb[0]->priority,
                $createdTaskDb[0]->proyect_id,
                $createdTaskDb[0]->status,
                $createdTaskDb[0]->date,
                TaskTypeEnum::Task,
            );

        } else {
            return null;
        }
    }

    public function delete() {
    }

    public function addComment() {
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects_tasks ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects_tasks WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $proyectsTasksDb = DB::select($queryString, $queryValues);

        $proyectsTasks = array();

        foreach ($proyectsTasksDb as $actualProyectTask) {
            $proyectsTasks[] = new Task(
                $actualProyectTask->id,
                $actualProyectTask->title,
                $actualProyectTask->description,
                $actualProyectTask->tag,
                $actualProyectTask->time,
                $actualProyectTask->priority,
                $actualProyectTask->proyect_id,
                $actualProyectTask->status,
                $actualProyectTask->date);
        }

        return $proyectsTasks;
    }
}
