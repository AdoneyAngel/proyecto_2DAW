<?php

namespace App\Models;

use Error;
use Exception;
use Illuminate\Database\Eloquent\Model;

class responseUtils extends Model
{
    public static function notFound($message) {
        return self::response(false, null, 404, $message);
    }
    public static function unAuthorized($message = "Unauthorized") {
        return self::response(false, null, 401, $message);
    }
    public static function serverError($log, Exception|null $err = null, $message = "Server error") {
        $logMessage = $err ? "\n -------------- \n $log \n ERROR: ".$err->getMessage()." \n FILE: " . $err->getFile() . "\n ON LINE ". $err->getLine() . "\n -------------- \n" : $log;

        return self::response(false, null, 500, $message, $logMessage);
    }
    public static function successful($data = null, $status = 200) {
        return self::response(true, $data, $status, "");
    }
    public static function created($data = null, $status = 201) {
        return self::response(true, $data, $status, "");
    }
    public static function invalidParams($message = "Invalid params") {
        return self::response(false, null, 422, $message);
    }
    public static function conflict($message) {
        return self::response(false, null, 409, $message);
    }
    public static function file($file) {
        return self::responseFile($file);
    }

    public static function responseFile($file) {
        return response()->file($file);
    }

    public static function response(bool $success, $data, $status, $error, $logMessage = null) {

        if ($logMessage) {
            error_log($logMessage);
        }

        return response()->json([
            "success" => $success,
            "data" => $data,
            "error" => $error
        ], $status)->header('Access-Control-Allow-Origin', '*')
                            ->header('Access-Control-Allow-Methods', '*')
                            ->header('Access-Control-Allow-Credentials', true)
                            ->header('Access-Control-Allow-Headers', 'X-Requested-With,Content-Type,X-Token-Auth,Authorization')
                            ->header('Accept', 'application/json');
    }
}
