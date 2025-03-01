<?php

namespace App\Http\Controllers;

use App\Http\Requests\Task\AddTaskUserRequest;
use App\Http\Requests\Task\StoreTaskRequest;
use App\Http\Requests\Task\UpdateTaskRequest;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\Task\TaskResource;
use App\Http\Resources\User\UserCollection;
use App\Models\Proyect;
use App\Models\responseUtils;
use App\Models\Task;
use App\Models\User;
use App\TaskStatusEnum;
use App\TaskTypeEnum;
use Exception;
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
            //Validate if the user is owner of the proyect
            $user = $request["user"];
            $proyect = Proyect::getById($request->proyectId);

            if ($proyect->getOwnerId() != $user->getId()) {
                return response()->json([
                    "success" => false,
                    "error" => "You are not the owner of the proyect"
                ]);
            }


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
    public function show(Request $request, $id)
    {
        try {
            $user = $request["user"];
            $task = Task::getById($id);
            $proyect = Proyect::getById($task->getProyectId());

            //Task exist
            if (!$task) {
                return response()->json([
                    "success" => false,
                    "error" => "Task not found"
                ], 404);
            }

            //User is owner/member of the proyect
            if ($proyect->getOwnerId() != $user->getId() && !$proyect->isMember($user->getId())) {
                return response()->json([
                    "success" => false,
                    "error" => "You can't access to this proyect"
                ], 401);
            }

            return response()->json([
                "success" => true,
                "data" => new TaskResource($task)
            ]);

        } catch (\Exception $err) {
            error_log("Error getting task: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateTaskRequest $request, $id)
    {
        try {
            $user = $request["user"];
            $task = Task::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return response()->json([
                    "success" => false,
                    "error" => "Task not found"
                ], 404);
            }

            //The use is owner of the proyect
            $proyect = Proyect::getById($task->getProyectId());

            if ($proyect->getOwnerId() != $user->getId()) {
                return response()->json([
                    "success" => false,
                    "error" => "You don't own the proyect of this task"
                ], 401);
            }

            $hasChanges = false;

            if ($request->title) {
                $task->setTitle($request->title);
                $hasChanges = true;
            }
            if ($request->description) {
                $task->setDescription($request->description);
                $hasChanges = true;
            }
            if ($request->tag) {
                $task->setTag($request->tag);
                $hasChanges = true;
            }
            if ($request->priority) {
                $task->setPriority($request->priority);
                $hasChanges = true;
            }
            if ($request->time) {
                $task->setTime($request->time);
                $hasChanges = true;
            }

            if (!$hasChanges) {
                return response()->json([
                    "success" => true,
                    "data" => new TaskResource($task)
                ]);
            }

            $updatedTask = $task->saveChanges();

            if ($updatedTask) {
                return response()->json([
                    "success" => true,
                    "data" => new TaskResource($task)
                ]);

            }

            return response()->json([
                "success" => false,
                "error" => "Something gone worng"
            ], 500);


        } catch (\Exception $err) {
            error_log("Error updating task: ". $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    /**
     * Add user into a task.
     */
    public function addUser(AddTaskUserRequest $request, $id) {
        try {
            $reqUser = $request["user"];
            $task = Task::getById($id);
            $proyect = null;
            $user = User::getById($request->userId);

            //User exist
            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //Is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You are not the owner of this proyect");
            }

            //The user already has assigned this user
            if ($task->isJoined($user)) {
                return responseUtils::conflict("The user already has assigned this task");
            }

            $addedUser = $task->addUser($user);

            if ($addedUser) {
                return responseUtils::successful();

            }

            return responseUtils::serverError("Something gone wrong adding user into a task", "Can't add the user, try again later");

        } catch (Exception $err) {
            return responseUtils::serverError("Error adding user into a task: ". $err->getMessage());
        }
    }

    /**
     * Get users of the task.
     */
    public function getUsers(Request $request, $id) {
        try {
            $reqUser = $request["user"];
            $task = Task::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            //the user is owner/member of the proyect
            $proyect = Proyect::getById($task->getProyectId());

            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You are not owner/member of this proyect");
            }

            $users = $task->getUsers();

            return responseUtils::successful(new UserCollection($users));

        } catch (Exception $err) {
            return responseUtils::serverError("Error getting users of task: ". $err->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
