<?php

namespace App\Models;

use App\TaskTypeEnum;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class TaskHistory extends Model
{
    protected $id;
    protected $taskId;
    protected $newStatus;
    protected $date;
    protected $task;

    public function __construct($id = 0, $taskId = 0, $newStatus = 0, $date = "", Task|null $task = null) {
        $this->id = $id;
        $this->taskId = $taskId;
        $this->newStatus = $newStatus;
        $this->date = $date;
        $this->task = $task;
    }

    //Getters & setters
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->$id = $id;
    }
    public function getNewStatus() {
        return $this->newStatus;
    }
    public function setNewStatus($newStatus) {
        $this->newStatus = $newStatus;
    }
    public function getDate() {
        return $this->date;
    }
    public function setDate($date) {
        $this->date = $date;
    }
    public function getTaskId() {
        return $this->taskId;
    }
    public function setTaskId($taskId) {
        $this->taskId = $taskId;
    }
    public function getTask() {
        return $this->task;
    }
    public function setTask(Task $task) {
        $this->task = $task;
    }

    //Methods
    public static function getAll() {
        $historyDb = DB::select("CALL proyects_tasks_history_select()");
        $history = [];

        if (count($historyDb)) {
            foreach ($historyDb as $historyDbItem) {
                $task = new Task(
                    $historyDbItem->task_id,
                    $historyDbItem->task_title,
                    $historyDbItem->task_description,
                    $historyDbItem->task_tag,
                    $historyDbItem->task_time,
                    $historyDbItem->task_priority,
                    $historyDbItem->task_proyect_id,
                    $historyDbItem->task_status,
                    $historyDbItem->task_date,
                    TaskTypeEnum::from($historyDbItem->task_type)
                );

                $history[] = new TaskHistory(
                    $historyDbItem->id,
                    $historyDbItem->task_id,
                    $historyDbItem->new_status,
                    $historyDbItem->date,
                    $task
                );
            }
        }

        return $history;

    }
    public static function getByProyectId($proyectId) {
        $historyDb = DB::select("CALL proyects_tasks_history_of_proyect_id(?)", [$proyectId]);
        $history = [];

        if (count($historyDb)) {
            foreach ($historyDb as $historyDbItem) {
                $task = new Task(
                    $historyDbItem->task_id,
                    $historyDbItem->task_title,
                    $historyDbItem->task_description,
                    $historyDbItem->task_tag,
                    $historyDbItem->task_time,
                    $historyDbItem->task_priority,
                    $historyDbItem->task_proyect_id,
                    $historyDbItem->task_status,
                    $historyDbItem->task_date,
                    TaskTypeEnum::from($historyDbItem->task_type)
                );

                $history[] = new TaskHistory(
                    $historyDbItem->id,
                    $historyDbItem->task_id,
                    $historyDbItem->new_status,
                    $historyDbItem->date,
                    $task
                );
            }
        }

        return $history;

    }

    public static function getByTaskId ($taskId) {
        $dbRes = DB::select("CALL proyects_tasks_history_id(?)", [$taskId]);

        if (count($dbRes)) {
            $history = [];

            foreach ($dbRes as $reg) {
                $actualRegTask = new Task(
                    $taskId,
                    $reg->proyects_tasks_title,
                    $reg->proyects_tasks_description,
                    $reg->proyects_tasks_tag,
                    $reg->proyects_tasks_time,
                    $reg->proyects_tasks_priority,
                    $reg->proyects_tasks_proyect_id,
                    $reg->proyects_tasks_status,
                    $reg->proyects_tasks_date,
                    TaskTypeEnum::from($reg->proyects_tasks_type));

                $actualTaskHistoryReg = new TaskHistory(
                    $reg->id,
                    $taskId,
                    $reg->new_status,
                    $reg->date,
                    $actualRegTask
                );

                $history[] = $actualTaskHistoryReg;
            }

            return $history;

        } else {
            return [];
        }
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects_tasks_history ";
        $queryValues = [];

        if ($whereValues && count($whereValues)) {
            $queryString = "SELECT * FROM proyects_tasks_history WHERE ";

            foreach ($whereValues as $actualWhereAttr => $actualWhereValue) {
                $queryString .= (string)$actualWhereAttr ."=? ";
                $queryValues[] = (string)$actualWhereValue;
            }
        }

        $historyDb = DB::select($queryString, $queryValues);

        $history = array();

        foreach ($historyDb as $actualHistoryItem) {
            $task = new Task(
                $actualHistoryItem->task_id,
                $actualHistoryItem->title,
                $actualHistoryItem->description,
                $actualHistoryItem->tag,
                $actualHistoryItem->time,
                $actualHistoryItem->priority,
                $actualHistoryItem->proyect_id,
                $actualHistoryItem->status,
                $actualHistoryItem->task_date,
                $actualHistoryItem->type
            );
            $history[] = new TaskHistory($actualHistoryItem->id, $actualHistoryItem->task_id, $actualHistoryItem->new_status, $actualHistoryItem->date, $task);
        }

        return $history;
    }

}
