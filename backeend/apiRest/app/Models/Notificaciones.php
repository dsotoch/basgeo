<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notificaciones extends Model
{
    protected $fillable = [
        'usuario_id',
        'dia',
        'fecha',
        'hora_predecible',
        'hora_llegada'
    ];

    public function usuario()
    {
        return $this->belongsTo(User::class);
    }
}
