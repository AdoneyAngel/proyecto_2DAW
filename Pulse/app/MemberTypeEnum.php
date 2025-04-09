<?php

namespace App;

enum MemberTypeEnum: int
{
    case Admin = 1;
    case Member = 2;
    case Viewer = 3;
}
