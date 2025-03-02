<?php

namespace App\Http\Resources\MemberHistory;

use App\Http\Resources\User\UserResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MemberHistoryResource extends JsonResource
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
            "action" => $this->getAction(),
            "date" => $this->getDate(),
            "userId" => $this->getUserId(),
            "proyectId" => $this->getProyectId(),
            "user" => $this->getUser() ? new UserResource($this->getUser()) : null
        ];
    }
}
