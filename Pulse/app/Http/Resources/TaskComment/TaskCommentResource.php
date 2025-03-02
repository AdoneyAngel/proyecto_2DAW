<?php

namespace App\Http\Resources\TaskComment;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskCommentResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "id" => $this->getId(),
            "comment" => $this->getComment(),
            "userId" => $this->getUserId(),
            "taskId" => $this->getTaskId(),
            "date" => $this->getDate()
        ];
    }
}
