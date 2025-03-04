<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ProyectMember extends User
{
    protected $status;
    protected $effectiveTime;
    protected $proyectId;
    protected $proyect;

    public function __construct($id = null, $username = "", $email = "", $password = "", $photo = null, $registred = null, $status = 0, $effectiveTime = 1, $proyectId = -1, Proyect|null $proyect = null)
    {
        parent::__construct($id, $username, $email, $password, $photo, $registred);

        $this->status = $status;
        $this->effectiveTime = $effectiveTime;
        $this->proyectId = $proyectId;
        $this->proyect = $proyect;
    }

    //Getters & setters
    public function getStatus()
    {
        return $this->status;
    }
    public function setStatus(int $status)
    {
        if ($status !== -1 && $status !== 0 && $status !== 1) return false;

        $this->status = $status;
        return true;
    }
    public function getEffectiveTime()
    {
        return $this->effectiveTime;
    }
    public function setEffectiveTime(int $effectiveTime)
    {
        if (!$effectiveTime) return false;

        $this->effectiveTime = $effectiveTime;
        return true;
    }
    public function getProyectId()
    {
        return $this->proyectId;
    }
    public function setProyectId(int $id)
    {
        if (!$id) return false;

        $this->proyectId = $id;
        return true;
    }

    //Methods
    public function buildFromUser(User $user, $status = null, $effectiveTime = null, $proyectId = null)
    {
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

    public static function getPendingProyectMemberRequestByProyectId($proyectId)
    {
        if (!$proyectId) return null;

        $requestsDb = DB::select("CALL proyects_members_select_pendings_of_proyect_id(?)", [$proyectId]);

        $requests = [];

        if (count($requestsDb)) {
            foreach ($requestsDb as $actualRequest) {
                $requests[] = new ProyectMember(
                    $actualRequest->user_id,
                    $actualRequest->user_username,
                    $actualRequest->user_email,
                    $actualRequest->user_password,
                    $actualRequest->user_photo,
                    $actualRequest->user_registred,
                    $actualRequest->status,
                    $actualRequest->effective_time,
                    $actualRequest->proyect_id
                );
            }
        }

        return $requests;
    }

    public static function getPendingProyectMemberRequestByUserId($userId)
    {
        if (!$userId) return null;

        $requestsDb = DB::select("CALL proyects_members_select_pendings_of_user_id(?)", [$userId]);

        $requests = [];

        if (count($requestsDb)) {
            foreach ($requestsDb as $actualRequest) {
                $requests[] = new ProyectMember(
                    $actualRequest->user_id,
                    $actualRequest->user_username,
                    $actualRequest->user_email,
                    $actualRequest->user_password,
                    $actualRequest->user_photo,
                    $actualRequest->user_registred,
                    $actualRequest->status,
                    $actualRequest->effective_time,
                    $actualRequest->proyect_id
                );
            }
        }

        return $requests;
    }

    public function loadProyect()
    {
        if (!$this->proyectId) return null;

        $proyect = Proyect::getById($this->proyectId);

        $this->proyect = $proyect;
    }

    public static function getByMemberIdProyectId($memberId, $proyectId) {
        $membersDb = DB::select("CALL proyects_members_of_user_id_proyect_id(?, ?)", [$memberId, $proyectId]);

        if (count($membersDb)) {
            return new ProyectMember(
                $membersDb[0]->user_id,
                $membersDb[0]->user_username,
                $membersDb[0]->user_email,
                $membersDb[0]->user_password,
                $membersDb[0]->user_photo,
                $membersDb[0]->user_registred,
                $membersDb[0]->status,
                $membersDb[0]->effective_time,
                $membersDb[0]->proyect_id
            );
        }

        return null;
    }

    public function getProyect()
    {
        return $this->proyect;
    }


    public function saveMemberChanges() {
        if (!$this->id) return null;
        if (!$this->proyectId) return null;
        if (!$this->username) return null;
        if (!$this->email) return null;
        if (!$this->effectiveTime) return null;

        $updatedMemberDb = DB::select("CALL proyects_members_update(?,?,?,?)", [$this->id, $this->proyectId, $this->status, $this->effectiveTime]);

        if (count($updatedMemberDb)) {
            return new ProyectMember(
                $updatedMemberDb[0]->user_id,
                $updatedMemberDb[0]->user_username,
                $updatedMemberDb[0]->user_email,
                $updatedMemberDb[0]->user_password,
                $updatedMemberDb[0]->user_photo,
                $updatedMemberDb[0]->user_registred,
                $updatedMemberDb[0]->status,
                $updatedMemberDb[0]->effective_time,
                $updatedMemberDb[0]->proyect_id
            );
        }

        return null;
    }
}
