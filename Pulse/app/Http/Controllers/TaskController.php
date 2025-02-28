<?php

namespace App\Http\Controllers;

use App\Http\Requests\Task\StoreTaskRequest;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\Task\TaskResource;
use App\Models\Task;
use App\TaskStatusEnum;
use App\TaskTypeEnum;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $tasks = Task::getAll();

            return response()->json([
                "success" => true,
                "data" => new TaskCollection($tasks)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting tasks: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreTaskRequest $request)
    {
        try {
            $newTask = new Task(
                null,
                $request->title,
                $request->description,
                $request->tag,
                $request->time,
                $request->priority,
                $request->proyectId,
                TaskStatusEnum::Progress,
                "",
                TaskTypeEnum::Task
            );

            $createdTask = $newTask->create();

            if ($createdTask) {
                return response()->json([
                    "success" => true,
                    "data" => new TaskResource($newTask)
                ], 201);

            } else {
                return response()->json([
                    "success" => false,
                    "Error" => "Can't make this task"
                ]);
            }

        } catch (\Exception $err) {
            error_log("Error creating task: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
