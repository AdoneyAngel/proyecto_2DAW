<?php

namespace App\Http\Resources\Proyect;

use App\Http\Resources\ProyectMember\ProyectMemberCollection;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\User\UserResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProyectResource extends JsonResource
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
            "title" => $this->getTitle(),
            "ownerId" => $this->getOwnerId(),
            "date" => $this->getDate(),
            "members" => $this->members ? new ProyectMemberCollection($this->members) : [],
            "tasks" => $this->tasks ? new TaskCollection($this->tasks) : [],
            "owner" => $this->owner ? new UserResource($this->owner) : null
        ];
    }
}
