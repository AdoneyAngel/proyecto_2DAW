<?php

namespace App\Http\Resources\TaskHistory;

use App\Http\Resources\Task\TaskResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskHistoryResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $resource = [
            "id" => $this->getId(),
            "taskId" => $this->getTaskId(),
            "newStatus" => $this->getNewStatus(),
            "date" => $this->getDate(),
        ];

        if ($this->getTask()) {
            $resource["task"] = new TaskResource($this->getTask());
        }

        return $resource;
    }
}
