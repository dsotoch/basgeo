<?php

namespace App\Http\Controllers;

use App\Models\Ubicacion;
use Illuminate\Http\Request;

class ApiControllerUbicacion extends Controller
{
    public function store(Request $request)
    {
        try {
            $request->validate(['latitud' => 'required', 'longitud' => 'required', 'usuario_id' => 'required']);
            $latitud = $request->input('latitud');
            $longitud = $request->input('longitud');
            $usuario_id = $request->input('usuario_id');

            $ubicacion = Ubicacion::create([
                'latitud' => $latitud,
                'longitud' => $longitud,
                'usuario_id' => $usuario_id,
            ]);

            return response()->json(['mensaje' => $ubicacion], 200);
        } catch (\Throwable $th) {
            return response()->json(['mensaje' => 'ocurrio un error:' + $th->getMessage()], 500);
        }
    }
}
