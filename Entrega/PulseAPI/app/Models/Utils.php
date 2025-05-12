<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Utils extends Model
{
    public static function parseBool($text) {
        return $text === true || strtolower($text) === "true";
    }
}
