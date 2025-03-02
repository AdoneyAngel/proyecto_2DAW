<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class TaskComment extends Model
{
    protected $id;
    protected $comment;
    protected $date;
    protected $taskId;
    protected $userId;

    public function __construct($id = 0, $comment = "", $date = "", $taskId = 0, $userId = 0)
    {
        $this->id = $id;
        $this->comment = $comment;
        $this->date = $date;
        $this->taskId = $taskId;
        $this->userId = $userId;
    }

    //Getters & setters
    public function getId()
    {
        return $this->id;
    }
    public function setId($id)
    {
        $this->id = $id;
    }
    public function getComment()
    {
        return $this->comment;
    }
    public function setComment(string $comment)
    {
        $this->comment = $comment;
    }
    public function getDate()
    {
        return $this->date;
    }
    public function setDate(string $date)
    {
        $this->date = $date;
    }
    public function getTaskId()
    {
        return $this->taskId;
    }
    public function setTaskId($taskId)
    {
        $this->taskId = $taskId;
    }
    public function getUserId()
    {
        return $this->userId;
    }
    public function setUserId($userId)
    {
        $this->userId = $userId;
    }

    //Methods
    public static function getAll()
    {
        $tasks = self::selectQuery();

        return $tasks;
    }
    public static function getById($id)
    {
        $tasks = self::selectQuery(["id" => $id]);

        return $tasks;
    }
    public static function getByUserId($userId)
    {
        $tasks = self::selectQuery(["user_id" => $userId]);

        return $tasks;
    }
    public static function getByTaskId($taskId)
    {
        $tasks = self::selectQuery(["task_id" => $taskId]);

        return $tasks;
    }
    public function create()
    {
        if (!$this->comment || !strlen($this->comment)) return null;
        if (!$this->taskId) return null;
        if (!$this->userId) return null;

        $createdCommentDb = DB::select("CALL proyects_tasks_comments_insert(?,?,?)", [$this->taskId, $this->userId, $this->comment]);

        if (count($createdCommentDb)) {
            $this->id = $createdCommentDb[0]->id;
            $this->date = $createdCommentDb[0]->date;

            return new TaskComment($createdCommentDb[0]->id,
            $createdCommentDb[0]->comment,
            $createdCommentDb[0]->date,
            $createdCommentDb[0]->task_id,
            $createdCommentDb[0]->user_id);
        }

        return null;
    }

    public static function selectQuery(array $whereValues = null)
    {
        $queryString = "SELECT * FROM proyects_tasks_comments ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects_tasks_comments WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr . "=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $tasksCommentsDb = DB::select($queryString, $queryValues);

        $tasksComments = array();

        foreach ($tasksCommentsDb as $actualComment) {
            $tasksComments[] = new TaskComment(
                $actualComment->id,
                $actualComment->comment,
                $actualComment->date,
                $actualComment->task_id,
                $actualComment->user_id
            );
        }

        return $tasksComments;
    }
}
