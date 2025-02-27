<?php

namespace App\Http\Resources\Proyect;

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
            "date" => $this->getDate()
        ];
    }
}
