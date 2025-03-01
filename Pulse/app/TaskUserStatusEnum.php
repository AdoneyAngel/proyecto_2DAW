<?php

namespace App;

enum TaskUserStatusEnum: int
{
    case Todo = 1;
    case Progress = 2;
    case Done = 3;
}
