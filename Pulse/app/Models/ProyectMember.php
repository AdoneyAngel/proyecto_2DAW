<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProyectMember extends User
{
    protected $status;
    protected $effectiveTime;
    protected $proyectId;

    public function __construct($id = null, $username = "", $email = "", $password = "", $photo = null, $registred = null, $status = 0, $effectiveTime = 1, $proyectId = -1) {
        parent::__construct($id, $username, $email, $password, $photo, $registred);

        $this->status = $status;
        $this->effectiveTime = $effectiveTime;
        $this->proyectId = $proyectId;
    }

    //Getters & setters
    public function getStatus() {
        return $this->status;
    }
    public function setStatus(int $status) {
        if ($status !== -1 && $status !== 0 && $status !== 1) return false;

        $this->status = $status;
        return true;
    }
    public function getEffectiveTime() {
        return $this->effectiveTime;
    }
    public function setEffectiveTime(int $effectiveTime) {
        if (!$effectiveTime) return false;

        $this->effectiveTime = $effectiveTime;
        return true;
    }
    public function getProyectId() {
        return $this->proyectId;
    }
    public function setProyectId(int $id) {
        if (!$id) return false;

        $this->proyectId = $id;
        return true;
    }

    //Methods
    public function getProyect() {
        $proyect = Proyect::getById($this->proyectId);

        return $proyect;
    }

    public function buildFromUser(User $user, $status = null, $effectiveTime = null, $proyectId = null) {
        if ($status) {
            $this->status = $status;
        }
        if ($effectiveTime) {
            $this->effectiveTime = $effectiveTime;
        }
        if ($proyectId) {
            $this->proyectId = $proyectId;
        }

        $this->id = $user->getId();
        $this->username = $user->getUserName();
        $this->password = $user->getPassword();
        $this->email = $user->getEmail();
        $this->photo = $user->getPhoto();
        $this->registred = $user->getRegistred();
    }

}
