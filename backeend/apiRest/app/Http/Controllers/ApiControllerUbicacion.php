<?php

namespace App\Http\Controllers;

use App\Models\Notificaciones;
use App\Models\Ubicacion;
use Illuminate\Http\Request;
use Illuminate\Notifications\Notification;

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

    public function guardarNotificacion(Request $request)
    {
        try {
            $request->validate([
                'usuario_id' => 'required',
                'dia' => 'required',
                'fecha' => 'required',
                'hora_predecible' => 'required',
                'hora_llegada' => 'required'
            ]);

            Notificaciones::create([
                'usuario_id' => $request->user()->id,
                'dia' => $request->dia,
                'fecha' => $request->fecha,
                'hora_predecible' => $request->hora_predecible,
                'hora_llegada' => $request->hora_llegada,
            ]);

            return response()->json(['mensaje' => 'Registro creado exitosamente.'], 200);
        } catch (\Throwable $th) {
            return response()->json(['mensaje' => $th->getMessage()], 500);
        }
    }

    public function actualizarNotificacion(Request $request)
    {
        try {
            $request->validate([
                'hora_llegada' => 'required'
            ]);
            $usuario_actual = $request->user()->id;

            $notificacion = Notificaciones::where('usuario_id', $usuario_actual)
                ->orderBy('id', 'desc')
                ->first();
                
            $notificacion->update(['hora_llegada' => $request->hora_llegada]);


            return response()->json(['mensaje' => 'Registro modificado exitosamente.'], 200);
        } catch (\Throwable $th) {
            return response()->json(['mensaje' => $th->getMessage()], 500);
        }
    }
}
