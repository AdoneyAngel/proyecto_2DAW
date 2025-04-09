<?php

namespace App\Http\Resources\ProyectMember;

use App\Http\Resources\Proyect\ProyectResource;
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
        $resource = [
            "id" => $this->getId(),
            "username" => $this->getUserName(),
            "email" => $this->getEmail(),
            "photo" => $this->getPhoto(),
            "registred" => $this->getRegistred(),
            "status" => $this->getStatus(),
            "effectiveTime" => $this->getEffectiveTime(),
            "proyectId" => $this->getProyectId(),
            "type" => $this->getType()
        ];

        if ($this->getProyect()) {
            $resource["proyect"] = new ProyectResource($this->getProyect());
        }

        return $resource;
    }
}
