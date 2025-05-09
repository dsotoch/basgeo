<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notification;

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
    public function notificacion(){
        return $this->hasMany(Notificaciones::class);
    }
}
