<?php

namespace App\Models;

use App\TaskStatusEnum;
use App\TaskTypeEnum;
use App\TaskUserStatusEnum;
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
        $tasks = static::selectQuery();

        return $tasks;
    }

    public static function getById($id) {
        $tasks = static::selectQuery(["id" => $id]);

        if (count($tasks)) {
            return $tasks[0];
        }

        return [];
    }

    public static function getByTitle($title) {
        $tasks = static::selectQuery(["title" => $title]);

        return $tasks;
    }

    public static function getByDescription($description) {
        $tasks = static::selectQuery(["description" => $description]);

        return $tasks;
    }

    public static function getByTag($tag) {
        $tasks = static::selectQuery(["tag" => $tag]);

        return $tasks;
    }

    public static function getByTime($time) {
        $tasks = static::selectQuery(["time" => $time]);

        return $tasks;
    }

    public static function getByPriority($priority) {
        $tasks = static::selectQuery(["priority" => $priority]);

        return $tasks;
    }

    public static function getByStatusId($statusId) {
        $tasks = static::selectQuery(["status" => $statusId]);

        return $tasks;
    }

    public static function getByProyectId($proyectId) {
        $tasks = static::selectQuery(["proyect_id" => $proyectId]);

        return $tasks;
    }

    public static function getByUserId($userId) {
        $tasksDb = DB::select("CALL proyects_tasks_of_user_id(?)", [$userId]);
        $tasks = [];

        if (count($tasksDb)) {

            foreach ($tasksDb as $actualTask) {
                $task = new Task(
                    $actualTask->id,
                    $actualTask->title,
                    $actualTask->description,
                    $actualTask->tag,
                    $actualTask->time,
                    $actualTask->priority,
                    $actualTask->proyect_id,
                    $actualTask->status,
                    $actualTask->date,
                    TaskTypeEnum::from($actualTask->type),
                );

                $task->userStatus = $actualTask->user_status;

                $tasks[] = $task;
            }

        }

        return $tasks;
    }

    public function getProyect() {
        if (!$this->proyectId) return null;

        $proyect = Proyect::getById($this->proyectId);

        return $proyect;
    }

    public function getUsers() {
        if (!$this->id) return null;

        $usersDb = DB::select("CALL users_of_proyects_tasks_id(?)", [$this->id]);

        if (count($usersDb)) {
            $users = [];

            foreach ($usersDb as $actualUser) {
                $user = new User(
                    $actualUser->id,
                    $actualUser->username,
                    $actualUser->email,
                    $actualUser->password,
                    $actualUser->photo,
                    $actualUser->registred
                );

                $user->taskStatus = $actualUser->status;

                $users[] = $user;

            }

            return $users;

        }

        return [];
    }

    public function loadUsers() {
        $users = $this->getUsers();

        $this->users = $users;
    }

    public function loadProyect() {
        if (!$this->proyectId) return null;

        $proyect = Proyect::getById($this->proyectId);

        $this->proyect = $proyect;
    }

    public function addUser(User $user) {
        if (!$this->id) return null;
        if (!$this->proyectId) return null;

        $addedUser = DB::select("CALL proyects_tasks_users_insert(?,?,?)", [$user->getId(), $this->id, TaskUserStatusEnum::Todo->value]);

        if (count($addedUser)) {
            return true;

        }

        return false;
    }

    public function removeUser(User $user) {
        if (!$this->id) return null;
        if (!$this->proyectId) return null;

        $deletedUser = DB::statement("CALL proyects_tasks_users_delete(?, ?)", [$this->id, $user->getId()]);

        return true;
    }

    public function isJoined(User $user): bool {

        $users = $this->getUsers();

        foreach($users as $actualUser) {
            if ($actualUser->getId() == $user->getId()) {
                return true;
            }
        }

        return false;
    }

    public function getStatus() {
        if (!$this->statusId) return null;

        $status = new TaskStatus(TaskStatusEnum::cases()[$this->statusId]);

        return $status;
    }

    public function getStatusByUser(User $user) {
        if (!$this->id) return null;

        $statusDb = DB::select("CALL proyects_tasks_user_status_of_proyects_tasks_id_users_id(?,?)", [$this->id, $user->getId()]);

        if (count($statusDb)) {
            return new TaskStatus($statusDb[0]->id, $statusDb[0]->name);
        }

        return null;

    }

    public function setUserStatus(User $user, TaskUserStatusEnum $status) {
        if (!$this->id) return null;

        $updatedUserDb = DB::select("CALL proyects_tasks_users_update(?,?,?)", [$this->id, $user->getId(), $status->value]);

        return true;

    }

    public function saveChanges() {
        if(!$this->id) return null;
        if(!$this->title || !strlen($this->title)) return null;
        if(!$this->tag || !strlen($this->tag)) return null;
        if($this->time <= 0) return null;
        if($this->priority <= 0) return null;
        if(!$this->proyectId) return null;

        $updatedTaskDb = DB::select("CALL proyects_tasks_update(?,?,?,?,?,?,?)", [$this->id, $this->title, $this->description, $this->tag, $this->time, $this->priority, $this->statusId]);

        if (count($updatedTaskDb)) {

            $this->title = $updatedTaskDb[0]->title;
            $this->description = $updatedTaskDb[0]->description;
            $this->tag = $updatedTaskDb[0]->tag;
            $this->time = $updatedTaskDb[0]->time;
            $this->priority = $updatedTaskDb[0]->priority;
            $this->status = $updatedTaskDb[0]->status;
            $this->statusId = $updatedTaskDb[0]->status;
            $this->date = $updatedTaskDb[0]->date;
            $this->type = TaskTypeEnum::from($updatedTaskDb[0]->type);

            return new Task(
                $this->id,
                $updatedTaskDb[0]->title,
                $updatedTaskDb[0]->description,
                $updatedTaskDb[0]->tag,
                $updatedTaskDb[0]->time,
                $updatedTaskDb[0]->priority,
                $updatedTaskDb[0]->proyect_id,
                $updatedTaskDb[0]->status,
                $updatedTaskDb[0]->date,
                TaskTypeEnum::from($updatedTaskDb[0]->type)
            );

        } else {
            return null;
        }
    }

    public function create() {
        if (!$this->title || !strlen($this->title)) return null;
        if (!$this->tag || !strlen($this->tag)) return null;
        if ($this->time <= 0) return null;
        if ($this->priority <= 0) return null;
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
        if (!$this->id) return null;

        $taskDeleted = DB::statement("CALL proyects_tasks_delete(?)", [$this->id]);

        return $taskDeleted;

    }

    public function addComment() {
    }

    public function setNextStatus() {
        if (!$this->id) return null;
        if (!$this->statusId) return null;

        $newStatus = TaskStatusEnum::tryFrom($this->statusId+1);

        if ($newStatus) {
            $newStatus = $newStatus->value;
            $this->statusId = $newStatus;
        }

        $this->saveChanges();

        return $newStatus;
    }

    public static function getTags($proyectId) {
        $tagsDb = DB::select("CALL proyects_tasks_select_tag_of_proyect_id(?)", [$proyectId]);
        $tags = [];

        if (count($tagsDb)) {
            foreach ($tagsDb as $actualTag) {
                $tags[] = $actualTag->tag;
            }
        }

        return $tags;
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects_tasks WHERE type=? ";
        $queryValues = [TaskTypeEnum::Task->value];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects_tasks WHERE type=? AND ";

            $nWhereValues = 0;

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                if ($nWhereValues) {
                    $queryString .= (string)$actualWhereAttr ."=? AND";

                } else {
                    $queryString .= (string)$actualWhereAttr ."=? ";
                }

                $queryValues[] = (string)$actualWhereValue;

                $nWhereValues++;
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
