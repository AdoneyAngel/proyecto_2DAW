<?php

namespace App;

enum TaskStatusEnum: int
{
    case Todo = 1;
    case Progress = 2;
    case Review = 3;
    case Done = 4;
}
