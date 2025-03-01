<?php

namespace App\Http\Resources\User;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            "registred" => $this->getRegistred()
        ];

        if ($this->token) {
            $resource["token"] = $this->token;
        }
        if ($this->taskStatus) {
            $resource["taskStatus"] = $this->taskStatus;
        }

        return $resource;
    }
}
