<?php

namespace App\Exceptions;

use App\Models\responseUtils;
use Exception;

class handler extends Exception
{
    public function render($request, $exception) {
        return responseUtils::serverError("Server error", $exception);
    }
}
