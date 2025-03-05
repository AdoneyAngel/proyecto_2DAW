<?php

namespace App\Http\Resources\Task;

use App\Http\Resources\Proyect\ProyectResource;
use App\Http\Resources\User\UserCollection;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskResource extends JsonResource
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
            "title" => $this->getTitle(),
            "description" => $this->getDescription(),
            "time" => $this->getTime(),
            "priority" => $this->getPriority(),
            "tag" => $this->getTag(),
            "statusId" => $this->getStatusId(),
            "proyectId" => $this->getProyectId(),
            "date" => $this->getDate(),
            "type" => $this->getType()
        ];

        if ($this->users) {
            $resource["users"] = new UserCollection($this->users);
        }

        if ($this->proyect) {
            $resource["proyect"] = new ProyectResource($this->proyect);
        }

        return $resource;
    }
}
