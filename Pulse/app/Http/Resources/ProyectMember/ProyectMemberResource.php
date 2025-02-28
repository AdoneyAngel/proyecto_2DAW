<?php

namespace App\Http\Resources\ProyectMember;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProyectMemberResource extends JsonResource
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
            "username" => $this->getUserName(),
            "email" => $this->getEmail(),
            "photo" => $this->getPhoto(),
            "registred" => $this->getRegistred(),
            "status" => $this->getStatus(),
            "effectiveTime" => $this->getEffectiveTime(),
            "proyectId" => $this->getProyectId()
        ];
    }
}
