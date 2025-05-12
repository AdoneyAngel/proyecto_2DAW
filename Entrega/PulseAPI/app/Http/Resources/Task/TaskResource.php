<?php

namespace App\Http\Resources\Task;

use App\Http\Resources\Proyect\ProyectResource;
use App\Http\Resources\User\UserCollection;
use App\Http\Resources\User\UserResource;
use App\Models\Issue;
use App\TaskTypeEnum;
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

        if ($this::class == Issue::class && $this->getNotifierId()) {
            $resource["notifierId"] = $this->getNotifierId();
        }

        if ($this::class == Issue::class && $this->getNotifier()) {
            $resource["notifier"] = new UserResource($this->getNotifier());
        }

        if ($this->proyect) {
            $resource["proyect"] = new ProyectResource($this->proyect);
        }

        return $resource;
    }
}
