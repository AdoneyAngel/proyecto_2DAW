<?php

namespace App\Models;

use App\TaskTypeEnum;
use Illuminate\Support\Facades\DB;

class Issue extends Task
{
    protected $notifierId;
    protected $notifier;

    public function __construct($id = -1, $title = "", $description = "", $tag = "", $time = 1, $priority = 0, $proyectId = 0, $statusId = 0, $date = 0, $type = TaskTypeEnum::Issue, $notifierId = 0, User|null $notifier = null) {
        parent::__construct(
            $id,
            $title,
            $description,
            $tag,
            $time,
            $priority,
            $proyectId,
            $statusId,
            $date,
            $type
        );

        $this->notifierId = $notifierId;
        $this->notifier = $notifier;
    }

    //Getters & setters
    public function getNotifierId() {
        return $this->notifierId;
    }
    public function setNotifierId($notifierId) {
        $this->notifierId = $notifierId;
    }
    public function getNotifier() {
        return $this->notifier;
    }

    //Methods
    public function loadNotifier() {
        if (!$this->notifierId) return null;

        $notifier = User::getById($this->notifierId);

        $this->notifier = $notifier;

        return $notifier;
    }

    public function create() {
        if (!$this->title || !strlen($this->title)) return null;
        if (!$this->tag || !strlen($this->tag)) return null;
        if (!$this->description || !strlen($this->description)) return null;
        if (!$this->time) return null;
        if ($this->priority < 0) return null;
        if (!$this->proyectId) return null;
        if (!$this->notifierId) return null;

        $createdIssueDb = DB::select("CALL proyects_tasks_insert_issue(?,?,?,?,?,?,?)", [
            $this->title,
            $this->description,
            $this->tag,
            $this->time,
            $this->priority,
            $this->proyectId,
            $this->notifierId
        ]);

        if (count($createdIssueDb)) {
            $this->id = $createdIssueDb[0]->id;
            $this->date = $createdIssueDb[0]->date;

            return new Issue(
                $createdIssueDb[0]->id,
                $createdIssueDb[0]->title,
                $createdIssueDb[0]->description,
                $createdIssueDb[0]->tag,
                $createdIssueDb[0]->time,
                $createdIssueDb[0]->priority,
                $createdIssueDb[0]->proyect_id,
                $createdIssueDb[0]->status,
                $createdIssueDb[0]->date,
                TaskTypeEnum::Task,
                $createdIssueDb[0]->user_id
            );

        } else {
            return null;
        }
    }

    public static function getByProyectId($proyectId) {
        $issues = static::selectQuery(["proyect_id" => $proyectId]);

        return $issues;
    }

    public static function selectQuery(array $whereValues = null) {
        $queryString = "SELECT * FROM proyects_tasks WHERE type=? ";
        $queryValues = [TaskTypeEnum::Issue->value];

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
            $proyectsTasks[] = new Issue(
                $actualProyectTask->id,
                $actualProyectTask->title,
                $actualProyectTask->description,
                $actualProyectTask->tag,
                $actualProyectTask->time,
                $actualProyectTask->priority,
                $actualProyectTask->proyect_id,
                $actualProyectTask->status,
                $actualProyectTask->date,
                TaskTypeEnum::Issue,
                $actualProyectTask->user_id
            );
        }

        return $proyectsTasks;
    }
}
