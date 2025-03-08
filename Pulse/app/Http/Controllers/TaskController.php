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
use App\Models\Utils;
use App\TaskStatusEnum;
use App\TaskTypeEnum;
use Exception;
use Illuminate\Http\Request;
use SebastianBergmann\CodeCoverage\Report\Xml\Project;

use function PHPUnit\Framework\isTrue;

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
            $users = [];

            if ($proyect->getOwnerId() != $user->getId()) {
                return responseUtils::unAuthorized("You are not the owner of the project");
            }

            //Can create and add users in the same request
            if ($request->users && count($request->users)) {
                //Users exist and is member of the proyect
                foreach ($request->users as $actualUser) {
                    $userFound = User::getById($actualUser);

                    if (!$userFound) {
                        return responseUtils::notFound("One of the users was not found");
                    }

                    if (!$proyect->isMember($actualUser)) {
                        return responseUtils::invalidParams("One of the users is not member of the project");
                    }

                    $users[] = $userFound;
                }
            }

            if ($request->time <= 0) {
                return responseUtils::invalidParams("The time must be more than 0");
            }
            if ($request->priority <= 0) {
                return responseUtils::invalidParams("The priority must be more than 0");
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
                //Add users
                if (count($users)) {
                    foreach ($users as $actualUser) {
                        $createdTask->addUser($actualUser);
                    }
                }
                return responseUtils::created(new TaskResource($newTask));

            } else {
                return responseUtils::serverError("Can't make this task", null, "Can't make this task");
            }

        } catch (Exception $err) {
            return responseUtils::serverError("Error creating task", $err);
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
                return responseUtils::notFound("Task not found");
            }

            //The use is owner of the proyect
            $proyect = Proyect::getById($task->getProyectId());

            if ($proyect->getOwnerId() != $user->getId()) {
                return responseUtils::unAuthorized("You don't own the proyect of this task");
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
                if ($request->priority <= 0) {
                    return responseUtils::invalidParams("The priority must be more than 0");
                }

                $task->setPriority($request->priority);
                $hasChanges = true;
            }
            if ($request->time) {
                if ($request->time <= 0) {
                    return responseUtils::invalidParams("The time must be more than 0");
                }
                $task->setTime($request->time);
                $hasChanges = true;
            }
            if ($request->statusId) {
                $task->setStatusId($request->statusId);
                $hasChanges = true;
            }

            if ($request->users && count($request->users)) {
                $hasChanges = true;
            }

            //Update the user list

            if ($request->users || is_array($request->users)) {
                $task->loadUsers();
                $taskUsers = $task->getUsers();

                 //Delete users
                foreach ($taskUsers as $user) {
                    $isIncluded = false;

                    foreach($request->users as $userFromRequest) {
                        if ($userFromRequest == $user->getId()) {
                            $isIncluded = true;
                        }
                    }

                    if (!$isIncluded) {
                        $task->removeUser($user);
                    }
                }

                //Add new users
                foreach ($request->users as $userFromRequest) {
                    $isIncluded = false;

                    foreach ($taskUsers as $user) {
                        if ($user->getId() == $userFromRequest) {
                            $isIncluded = true;
                        }
                    }

                    if (!$isIncluded) {
                        $newUser = User::getById($userFromRequest);

                        //User exist
                        if (!$newUser) {
                            return responseUtils::notFound("One of the users not found");
                        }

                        $task->addUser($newUser);
                    }
                }
            }

            if (!$hasChanges) {
                return responseUtils::successful(new TaskResource($task));
            }

            $updatedTask = $task->saveChanges();

            if ($updatedTask) {
                return responseUtils::successful(new TaskResource($task));
            }

            return responseUtils::serverError("Something gone worng");

        } catch (Exception $err) {
            return responseUtils::serverError("Error updating task", $err);
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
     * Add a list of users into a task.
    */
    public function addUsers(Request $request, $taskId) {
        try {
            $reqUser = $request["user"];
            $task = null;
            $proyect = null;

            if (!$request->users || !count($request->users)) {
                return responseUtils::invalidParams("Missing users");
            }

            $task = Task::getById($taskId);

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //Request user is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You can't update this project");
            }

            $users = [];

            foreach ($request->users as $userId) {
                $user = User::getById($userId);

                if (!$user) {
                    return responseUtils::notFound("One of users not found");
                }

                $users[] = $user;
            }

            foreach ($users as $user) {
                $task->addUser($user);
            }

            return responseUtils::successful(true);

        } catch (Exception $err) {
            return responseUtils::serverError("Error adding list of user into a task, TaskController", $err);
        }
    }

    /**
     * Remove user from task.
     */
    public function removeUser(Request $request, $id) {
        try {
            $reqUser = $request["user"];
            $proyect = null;
            $task = null;
            $user = null;

            if (!$request->userId) {
                return responseUtils::invalidParams("Missing user");
            }

            $task = Task::getById($id);

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //User is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You can't update this proyect");
            }

            $user = User::getById($request->userId);

            //User exist
            if (!$user) {
                return responseUtils::notFound("User not found");
            }

            $removedUser = $task->removeUser($user);

            return responseUtils::successful(true);

        } catch (Exception $err) {
            return responseUtils::serverError("Error removing user from task, TaskCotroller", $err);
        }
    }

    /**
     * Remove a list of users from task.
     */
    public function removeUsers(Request $request, $taskId) {
        try {
            $reqUser = $request["user"];
            $task = null;
            $proyect = null;

            if (!$request->users || !count($request->users)) {
                return responseUtils::invalidParams("Missing users");
            }

            $task = Task::getById($taskId);

            //Task exist
            if (!$task) {
                return responseUtils::notFound("Task not found");
            }

            $proyect = Proyect::getById($task->getProyectId());

            //Request user is owner of the proyect
            if ($proyect->getOwnerId() != $reqUser->getId()) {
                return responseUtils::unAuthorized("You can't update this project");
            }

            $users = [];

            foreach ($request->users as $userId) {
                $user = User::getById($userId);

                if (!$user) {
                    return responseUtils::notFound("One of users not found");
                }

                $users[] = $user;
            }

            foreach ($users as $user) {
                $task->removeUser($user);
            }

            return responseUtils::successful(true);

        } catch (Exception $err) {
            return responseUtils::serverError("Error removing list of user into a task, TaskController", $err);
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
        if (Utils::parseBool($request->query("users"))) {
            $task->loadUsers();
        }
        if (Utils::parseBool($request->query("proyect"))) {
            $task->loadProyect();
        }
    }
}
