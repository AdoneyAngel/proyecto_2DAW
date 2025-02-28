<?php

namespace App\Models;

use App\TaskStatusEnum;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class TaskStatus extends Model
{
    protected $id;
    protected $name;

    public function __construct($id = 0, $name = "") {
        $this->id = $id;
        $this->name = $name;

        if ($id) {
            $this->setStatus(TaskStatusEnum::cases()[$id]);
        }
    }

    //Getters & setters
    public function getId() {
        return $this->id;
    }
    public function setId($id) {
        $this->id = $id;
        return true;
    }
    public function getName() {
        return $this->name;
    }
    public function setName(string $name) {
        $this->name = $name;
        return true;
    }

    //Methods
    public function setStatus(TaskStatusEnum $status) {
        $statusId = $status->value;

        $statusDb = DB::select("SELECT * FROM proyects_tasks_status WHERE id=?", [$statusId]);

        if (count($statusDb)) {
            $this->id = $statusId;
            $this->name = $statusDb[0]->name;
        }
    }
}
