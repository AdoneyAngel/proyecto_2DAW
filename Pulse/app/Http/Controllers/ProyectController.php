<?php

namespace App\Http\Controllers;

use App\Http\Requests\Proyect\AddProyectMemberRequest;
use App\Http\Requests\Proyect\StoreProyectRequest;
use App\Http\Requests\Proyect\UpdateProyectRequest;
use App\Http\Resources\MemberHistory\MemberHistoryCollection;
use App\Http\Resources\Proyect\ProyectCollection;
use App\Http\Resources\Proyect\ProyectResource;
use App\Http\Resources\ProyectMember\ProyectMemberCollection;
use App\Http\Resources\ProyectMember\ProyectMemberResource;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\TaskHistory\TaskHistoryCollection;
use App\Models\Proyect;
use App\Models\ProyectMember;
use App\Models\responseUtils;
use App\Models\TaskHistory;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;

class ProyectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        try {
            $proyects = Proyect::getAll();

            //Load missing parameters
            $this->loadMissings($request, $proyects);

            return responseUtils::successful(new ProyectCollection($proyects));

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting proyects", $err);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreProyectRequest $request)
    {
        try {
            $user = $request["user"];

            //Validate if the proyect title is duplicated of the current user
            $proyectsOfUser = Proyect::getByOwnerId($user->getId());

            $proyectTitleExist = false;

            foreach ($proyectsOfUser as $proyect) {
                if ($proyect->getTitle() == $request->title) {
                    $proyectTitleExist = true;
                }
            }

            if ($proyectTitleExist) {
                return responseUtils::conflict("You already have this proyect");
            }

            $newProyect = new Proyect(null, $request->title, $user->getId(), null);
            $newProyect->create();

            return responseUtils::successful(new ProyectResource($newProyect));

        } catch (Exception $err) {
            return responseUtils::serverError("Error creating proyect", $err);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, $id)
    {
        try {
            $user = $request["user"];

            $proyect = Proyect::getById($id);

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            if ($proyect->getOwnerId() == $user->getId() || $proyect->isMember($user->getId())) {
                $this->loadMissing($request, $proyect);

                return responseUtils::successful(new ProyectResource($proyect));

            } else {
                return responseUtils::unAuthorized("You are not the owner of this proyect");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting proyect", $err);
        }
    }

    /**
     * Get members of the proyect.
     */
    public function getMembers(Request $request, $id) {
        try {
            $user = $request["user"];

            $proyect = Proyect::getById($id);

            if ($proyect->getOwnerId() == $user->getId() || $proyect->isMember($user->getId())) {
                $members = $proyect->getMembers();

                return responseUtils::successful(new ProyectMemberCollection($members));

            } else {
                return responseUtils::unAuthorized("You are not the owner of this proyect");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting proyect members", $err);
        }
    }

    /**
     * Add a new member to the proyect.
     */
    public function addMember(AddProyectMemberRequest $request, $proyectId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($proyectId);
            $user = User::getById($request->userId);

            //User exist
            if (!$user) {
                return response()->json([
                    "success" => false,
                    "error" => "User not found"
                ], 404);
            }

            //Proyect exist
            if (!$proyect) {
                return response()->json([
                    "success" => false,
                    "error" => "Proyect not found"
                ], 404);
            }

            //Current user is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return response()->json([
                    "success" => false,
                    "error" => "You are not the owner of this proyect"
                ], 401);
            }

            //User is already joined
            if ($proyect->isMember($user->getId())) {
                return response()->json([
                    "success" => false,
                    "error" => "The user is already in"
                ], 422);
            }

            //Add member
            $newMember = new ProyectMember();
            $newMember->buildFromUser($user, 0, $request->effectiveTime, $proyect->getId());

            $addedMember = $proyect->addMember($newMember);

            if ($addedMember) {
                return response()->json([
                    "success" => true,
                    "data" => new ProyectMemberResource($addedMember)
                ], 201);

            }

        } catch (\Exception $err) {
            error_log("Error adding member: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Get members history of the proyect.
     */
    public function getMembersHistory(Request $request, $id) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($id);

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            //Request user is owner/member of proyect
            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You are not owner/member of this proyect");
            }

            $history = $proyect->getMembersHistory();

            return responseUtils::successful(new MemberHistoryCollection($history));

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting member history, ProyectController", $err);
        }
    }

    /**
     * Get the task list of the proyect.
     */
    public function getTasks(Request $request, $proyectId) {
        try {
            $user = $request["user"];
            $proyect = Proyect::getById($proyectId);

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            //User is owner o member of proyect
            if ($proyect->getOwnerId() != $user->getId() && !$proyect->isMember($user->getId())) {
                return responseUtils::unAuthorized("You are not owner/member of this proyect");
            }

            $tasks = $proyect->getTasks();

            return responseUtils::successful(new TaskCollection($tasks));

        } catch (Exception $err) {
            return responseUtils::serverError("Error gettings tasks of proyect, ProyectController", $err);
        }
    }

    /**
     * Get tasks history of the proyect.
     */
    public function getTasksHistory(Request $request, $proyectId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($proyectId);

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            //Request user is owner/member of proyect
            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You are not owner/member of this proyect");
            }

            $history = TaskHistory::getByProyectId($proyect->getId());

            return responseUtils::successful(new TaskHistoryCollection($history));

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting tasks history of proyect, ProyectController", $err);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateProyectRequest $request, $id)
    {
        try {
            $user = $request["user"];
            $proyect = Proyect::getById($id);

            if ($proyect->getOwnerId() != $user->getId()) {
                return response()->json([
                    "success" => false,
                    "You are not the owner of this proyect"
                ], 401);
            }

            //Validate if the proyect title is duplicated of the current user
            $proyectsOfUser = Proyect::getByOwnerId($user->getId());

            $proyectTitleExist = false;

            foreach ($proyectsOfUser as $proyect) {
                if ($proyect->getTitle() == $request->title) {
                    $proyectTitleExist = true;
                }
            }

            if ($proyectTitleExist) {

                return response()->json([
                    "success" => false,
                    "error" => "You already have this proyect"
                ], 500);
            }

            //Update proyect
            if ((!$request->title || !strlen($request->title)) && !$request->ownerId) {
                //Load missing parameters
                $this->loadMissing($request, $proyect);

                return response()->json([
                    "success" => true,
                    "data" => new ProyectResource($proyect)
                ]);
            }

            if ($request->title) {
                $proyect->setTitle($request->title);
            }
            if ($request->ownerId) {
                $proyect->setOwnerId($request->ownerId);
            }

            $proyect->saveChanges();

            return response()->json([
                "success" => true,
                "data" => new ProyectResource($proyect)
            ]);

        } catch (Exception $err) {
            return responseUtils::serverError("Error updating proyect", $err);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id) {
    }

    /**
     * Get the pendings proyect join requests of the proyect
     */
    public function getUserPendingJoinOfProyect(Request $request, $proyectId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($proyectId);

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            //User is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You are not the owner of the proyect");
            }

            $pendingRequests = ProyectMember::getPendingProyectMemberRequestByProyectId($proyect->getId());

            return responseUtils::successful(new ProyectMemberCollection($pendingRequests));

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting pending join request of proyect, ProyectController", $err);
        }
    }

    /**
     * Get the member of the proyect, only if he's joined
     */
    public function showMember(Request $request, $id, $memberId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($id);
            $member = null;

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            $member = ProyectMember::getByMemberIdProyectId($memberId, $proyect->getId());
            //Request user is owner/member of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You cant access to this proyect");
            }

            //Member exist
            if (!$member) {
                return responseUtils::notFound("Member not found");
            }

            //The user found is member
            if (!$proyect->getId() == $member->getProyectId()) {
                return responseUtils::notFound("Member not found");
            }

            return responseUtils::successful(new ProyectMemberResource($member));


        } catch (Exception $err) {
            return responseUtils::serverError("Error getting an especific member on proyect, ProyectController", $err);
        }
    }

    /**
     * Update the member of the proyect
     */
    public function updateMember(Request $request, $id, $memberId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($id);
            $member = null;

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("ProyectNotFound");
            }

            //Request user is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You are unauthorized to modify members on this proyect");
            }

            $member = ProyectMember::getByMemberIdProyectId($memberId, $proyect->getId());

            //Member exist
            if (!$member) {
                return responseUtils::notFound("Member not found");
            }

            //Changes
            if ($request->status) {
                $member->setStatus($request->status);
            }
            if ($request->effectiveTime) {
                $member->setEffectiveTime($request->effectiveTime);
            }

            $member->saveMemberChanges();

            return responseUtils::successful(new ProyectMemberResource($member));

        } catch (Exception $err) {
            return responseUtils::serverError("Error updating member, ProyectController", $err);
        }
    }

    public function acceptProyectRequest(Request $request, $proyectId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($proyectId);
            $member = null;

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            $member = ProyectMember::getByMemberIdProyectId($reqUser->getId(), $proyect->getId());

            //The request user is the same who receved
            if ($member->getProyectId() != $proyect->getId()) {
                return responseUtils::unAuthorized("Can't accept this request");
            }

            //The request is on waiting status
            if ($member->getStatus() != 0) {
                return responseUtils::unAuthorized("Can't accept this request");
            }

            //Changes
            $member->setStatus(1);
            $member->saveMemberChanges();

            return responseUtils::successful(new ProyectMemberResource($member));

        } catch (Exception $err) {
            return responseUtils::serverError("Error accepting join request, ProyectController", $err);
        }
    }

    public function rejectProyectRequest(Request $request, $proyectId) {
        try {
            $reqUser = $request["user"];
            $proyect = Proyect::getById($proyectId);
            $member = null;

            //Proyect exist
            if (!$proyect) {
                return responseUtils::notFound("Proyect not found");
            }

            $member = ProyectMember::getByMemberIdProyectId($reqUser->getId(), $proyect->getId());

            //The request user is the same who receved
            if ($member->getProyectId() != $proyect->getId()) {
                return responseUtils::unAuthorized("Can't reject this request");
            }

            //Changes
            $member->setStatus(-1);
            $member->saveMemberChanges();

            return responseUtils::successful(new ProyectMemberResource($member));

        } catch (Exception $err) {
            return responseUtils::serverError("Error rejecting join request, ProyectController", $err);
        }
    }

    public function loadMissings(Request $request, &$proyects) {            //Load missing parameters
        foreach ($proyects as $proyect) {
            $this->loadMissing($request, $proyect);
        }
    }

    public function loadMissing(Request $request, &$proyect) {            //Load missing parameters
        if ($request->query("members")) {
            $proyect->loadMembers();
        }
        if ($request->query("tasks")) {
            $proyect->loadTasks();
        }
        if ($request->query("owner")) {
            $proyect->loadOwner();
        }
    }
}
