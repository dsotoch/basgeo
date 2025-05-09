<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Horarios extends Model
{
    protected $fillable=["estado","zona","horaFin","horaInicio","dia"];
}
