<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class responseUtils extends Model
{
    public static function notFound($message) {
        return self::response(false, null, 404, $message);
    }
    public static function unAuthorized($message = "Unauthorized") {
        return self::response(false, null, 401, $message);
    }
    public static function serverError($log, $message = "Server error") {
        return self::response(false, null, 500, $message, $log);
    }
    public static function successful($data = null, $status = 200) {
        return self::response(true, $data, $status, "");
    }
    public static function invalidParams($message = "Invalid params") {
        return self::response(false, null, 422, $message);
    }
    public static function conflict($message) {
        return self::response(false, null, 409, $message);
    }

    public static function response(bool $success, $data, $status, $error, $log = null) {

        if ($log) {
            error_log($log);
        }

        return response()->json([
            "success" => $success,
            "data" => $data,
            "error" => $error
        ], $status);
    }
}
