<?php

namespace App\Http\Controllers;

use App\Http\Requests\Issue\StoreIssueRequest;
use App\Http\Requests\Task\AddCommentRequest;
use App\Http\Requests\Task\AddTaskUserRequest;
use App\Http\Requests\Task\StoreTaskRequest;
use App\Http\Requests\Task\UpdateTaskRequest;
use App\Http\Resources\Task\TaskCollection;
use App\Http\Resources\Task\TaskResource;
use App\Http\Resources\TaskComment\TaskCommentCollection;
use App\Http\Resources\TaskComment\TaskCommentResource;
use App\Http\Resources\User\UserCollection;
use App\Models\Issue;
use App\Models\Proyect;
use App\Models\responseUtils;
use App\Models\Task;
use App\Models\TaskComment;
use App\Models\User;
use App\TaskStatusEnum;
use App\TaskTypeEnum;
use Exception;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    private $taskTypeClass = Task::class;

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        try {
            $tasks = $this->taskTypeClass::getAll();

            $this->loadMissings($request, $tasks);

            return responseUtils::successful(new TaskCollection($tasks));
        } catch (Exception $err) {
            return responseUtils::serverError("Error getting tasks", $err);
        }
    }

    /**
     * Display a listing of issues.
     */
    public function issueIndex(Request $request)
    {
        $this->taskTypeClass = Issue::class;
        return $this->index($request);
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
                return responseUtils::unAuthorized("You are not the owner of the proyect");
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
                return responseUtils::created(new TaskResource($newTask));

            } else {
                return responseUtils::serverError("Can't make this task", null, "Can't make this task");
            }
        } catch (Exception $err) {
            responseUtils::serverError("Error creating task", $err);
        }
    }

    /**
     * Create a newly created issue.
     */
    public function issueStore(StoreIssueRequest $request)
    {
        try {
            //Validate if the user is owner of the proyect
            $user = $request["user"];
            $proyect = Proyect::getById($request->proyectId);

            //Request user is owner/member of the proyect
            if ($proyect->getOwnerId() != $user->getId() && !$proyect->isMember($user->getId())) {
                return responseUtils::unAuthorized("You are not the owner of the proyect");
            }

            $newIssue = new Issue(
                null,
                $request->title,
                $request->description,
                $request->tag,
                $request->time,
                $request->priority,
                $request->proyectId,
                TaskStatusEnum::Progress,
                "",
                TaskTypeEnum::Task,
                $user->getId()
            );

            $createdIssue = $newIssue->create();

            if ($createdIssue) {
                return responseUtils::created(new TaskResource($newIssue));

            } else {
                return responseUtils::serverError("Can't make this issue", null, "Can't make this issue");
            }
        } catch (Exception $err) {
            responseUtils::serverError("Error creating issue, TaskController", $err);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Request $request, $id)
    {
        try {
            $user = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //User is owner/member of the proyect
            if ($proyect->getOwnerId() != $user->getId() && !$proyect->isMember($user->getId())) {
                return responseUtils::unAuthorized("You can't access to this proyect");
            }

            $this->loadMissing($request, $task);

            return responseUtils::successful(new TaskResource($task));
        } catch (Exception $err) {
            return responseUtils::serverError("Error getting task", $err);
        }
    }

    public function issueShow(Request $request, $id)
    {
        $this->taskTypeClass = Issue::class;
        return $this->show($request, $id);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateTaskRequest $request, $id)
    {
        try {
            $user = $request["user"];
            $task = $this->taskTypeClass::getById($id);
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
            if ($request->statusId) {
                $task->setStatusId($request->statusId);
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
            error_log("Error updating task: " . $err->getMessage());

            return response()->json([
                "success" => false,
                "error" => "Server error"
            ], 500);
        }
    }

    public function issueUpdate(UpdateTaskRequest $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->update($request, $id);
    }

    /**
     * Add user into a task.
     */
    public function addUser(AddTaskUserRequest $request, $id)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
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

            return responseUtils::serverError("Something gone wrong adding user into a task", null, "Can't add the user, try again later");
        } catch (Exception $err) {
            return responseUtils::serverError("Error adding user into a task", $err);
        }
    }

    /**
     * Add user into a issue.
     */
    public function issueAddUser(AddTaskUserRequest $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->addUser($request, $id);
    }

    /**
     * Get users of the task.
     */
    public function getUsers(Request $request, $id)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
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
            return responseUtils::serverError("Error getting users of task", $err);
        }
    }

    /**
     * Get users of the issue.
     */
    public function issueGetUsers(Request $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->getUsers($request, $id);
    }

    /**
     * Set the next status for the task.
     */
    public function nextStatus(Request $request, $id)
    {
        try {
            $user = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //User is owner
            if ($proyect->getOwnerId() != $user->getId()) {
                return responseUtils::unAuthorized("You are not the owner of this proyect");
            }

            $task->setNextStatus();

            return responseUtils::successful(new TaskResource($task));
        } catch (Exception $err) {
            return responseUtils::serverError("Error updating to the next status for the task, TaskController", $err);
        }
    }

    /**
     * Set the next status for the issue.
     */
    public function issueNextStatus(Request $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->nextStatus($request, $id);
    }

    /**
     * Set the next status for the user (waiting for join, joined or rejected).
     */
    public function getUserStatus(Request $request, $id, $userId)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $user = User::getById($userId);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            //User exist
            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            //Request user is owner/member of proyect
            $proyect = Proyect::getById($task->getProyectId());
            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You are not owner/member of the proyect");
            }

            $userStatus = $task->getStatusByUser($user);

            if ($userStatus) {
                return responseUtils::successful([
                    "statusId" => $userStatus->getId()
                ]);
            }

            return responseUtils::invalidParams("Invalid params or user has not asigned this task");
        } catch (Exception $err) {
            return responseUtils::serverError("Error getting status of user in a task, TaskController", $err);
        }
    }

    /**
     * Set the next status for the user (waiting for join, joined or rejected).
     */
    public function issueGetUserStatus(Request $request, $id, $userId) {
        $this->taskTypeClass = Issue::class;
        return $this->getUserStatus($request, $id, $userId);
    }

    /**
     * Add a new comment to task.
     */
    public function addComment(AddCommentRequest $request, $id)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            //Request user has asigned the task
            $proyect = Proyect::getById($task->getProyectId());
            if (!$task->isJoined($reqUser) && $proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You can't comment on this task");
            }

            $newComment = new TaskComment(0, $request->comment, "", $id, $reqUser->getId());
            $createdComment = $newComment->create();

            if ($createdComment) {
                return responseUtils::successful(new TaskCommentResource($newComment));
            }

            return responseUtils::serverError("Can't create the comment, TaskController", null, "Can't create the comment, try again");
        } catch (Exception $err) {
            return responseUtils::serverError("Error adding comment to task, TaskController", $err);
        }
    }

    /**
     * Add a new comment to issue.
     */
    public function issueAddComment(AddCommentRequest $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->addComment($request, $id);
    }

    /**
     * Get all comments of task.
     */
    public function getComments(Request $request, $id)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            //Request user is owner or has asigned this task
            $proyect = Proyect::getById($task->getProyectId());
            if ($proyect->getOwnerId() != $reqUser->getId() && !$proyect->isMember($reqUser->getId())) {
                return responseUtils::unAuthorized("You dont have access to this task");
            }

            $comments = TaskComment::getByTaskId($id);

            return responseUtils::successful(new TaskCommentCollection($comments));
        } catch (Exception $err) {
            return responseUtils::serverError("Error gettings comments of a task, TaskController", $err);
        }
    }

    public function issueGetComments(Request $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->getComments($request, $id);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, $id)
    {
        try {
            $reqUser = $request["user"];
            $task = $this->taskTypeClass::getById($id);
            $proyect = null;

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            //Request user is the owner of the proyect
            $proyect = Proyect::getById($task->getProyectId());

            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You are not the owner of the proyect");
            }

            $task->delete();

            return responseUtils::successful();

        } catch (Exception $err) {
            return responseUtils::serverError("Error deleting task, TaskController", $err);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function issueDestroy(Request $request, $id) {
        $this->taskTypeClass = Issue::class;
        return $this->destroy($request, $id);
    }

    public function loadMissings(Request $request, &$tasks)
    {            //Load missing parameters
        foreach ($tasks as $task) {
            $this->loadMissing($request, $task);
        }
    }

    public function loadMissing(Request $request, &$task)
    {
        //Load missing parameters
        if ($request->query("users")) {
            $task->loadUsers();
        }
        if ($request->query("proyect")) {
            $task->loadProyect();
        }
    }
}
