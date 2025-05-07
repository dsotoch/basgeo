<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ubicacion extends Model
{
    protected $fillable = [
        "latitud",
        "longitud",
        "usuario_id",
    ];

    public function usuario()
    {
        return $this->belongsTo(Usuario::class);
    }
}
