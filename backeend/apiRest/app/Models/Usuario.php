<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Usuario extends Model
{
    protected $fillable = [
        "nombre",
        "apellidos",
        "tipo",
        "direccion"
    ];

    public function ubicacion()
    {
        return $this->hasMany(Ubicacion::class);
    }
}
