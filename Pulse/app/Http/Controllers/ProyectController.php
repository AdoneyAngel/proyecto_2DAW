<?php

namespace App\Http\Controllers;

use App\Http\Requests\Proyect\StoreProyectRequest;
use App\Http\Requests\Proyect\UpdateProyectRequest;
use App\Http\Resources\Proyect\ProyectCollection;
use App\Http\Resources\Proyect\ProyectResource;
use App\Http\Resources\ProyectMember\ProyectMemberCollection;
use App\Models\Proyect;
use Illuminate\Http\Request;

class ProyectController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $proyects = Proyect::getAll();

            return response()->json([
                "success" => true,
                "data" => new ProyectCollection($proyects)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting proyects: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ]);
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
            ]);
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
            ]);
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
            ]);
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
                ]);
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
            ]);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id) {
    }
}
