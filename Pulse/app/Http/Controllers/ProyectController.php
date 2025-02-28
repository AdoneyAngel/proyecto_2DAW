<?php

namespace App\Http\Controllers;

use App\Http\Requests\Proyect\AddProyectMemberRequest;
use App\Http\Requests\Proyect\StoreProyectRequest;
use App\Http\Requests\Proyect\UpdateProyectRequest;
use App\Http\Resources\Proyect\ProyectCollection;
use App\Http\Resources\Proyect\ProyectResource;
use App\Http\Resources\ProyectMember\ProyectMemberCollection;
use App\Http\Resources\ProyectMember\ProyectMemberResource;
use App\Models\Proyect;
use App\Models\ProyectMember;
use App\Models\User;
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

            return response()->json([
                "success" => true,
                "data" => new ProyectCollection($proyects)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting proyects: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
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
                return response()->json([
                    "success" => false,
                    "error" => "You already have this proyect"
                ]);
            }

            $newProyect = new Proyect(null, $request->title, $user->getId(), null);
            $newProyect->create();

            return response()->json([
                "success" => true,
                "data" => new ProyectResource($newProyect)
            ]);

        } catch (\Exception $err) {
            error_log("Error creating proyect: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
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

            if ($proyect->getOwnerId() == $user->getId() || $proyect->isMember($user->getId())) {
                $this->loadMissing($request, $proyect);

                return response()->json([
                    "success" => true,
                    "data" => new ProyectResource($proyect)
                ]);

            } else {
                return response()->json([
                    "success" => false,
                    "You are not the owner of this proyect"
                ], 401);
            }

        } catch (\Exception $err) {
            error_log("Error getting proyect: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
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

                return response()->json([
                    "success" => true,
                    "data" => new ProyectMemberCollection($members)
                ]);

            } else {
                return response()->json([
                    "success" => false,
                    "You are not the owner of this proyect"
                ], 401);
            }

        } catch (\Exception $err) {
            error_log("Error getting proyect members: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
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

        } catch (\Exception $err) {
            error_log("Error updating proyect: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    public function addMember(AddProyectMemberRequest $request, $proyectId) {
        try {
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
            if ($proyect) {
                //User is already joined
                if ($proyect->isMember($user->getId())) {
                    return response()->json([
                        "success" => false,
                        "error" => "The use is already in"
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
     * Remove the specified resource from storage.
     */
    public function destroy(string $id) {
    }

    private function loadMissings(Request $request, &$proyects) {            //Load missing parameters
        foreach ($proyects as $proyect) {
            $this->loadMissing($request, $proyect);
        }
    }

    private function loadMissing(Request $request, &$proyect) {            //Load missing parameters
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
