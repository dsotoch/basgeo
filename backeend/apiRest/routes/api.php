<?php

use App\Http\Controllers\ApiControllerUbicacion;
use App\Http\Controllers\ApiControllerUsuario;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->get('/usuario', function (Request $request) {
    return response()->json([
        'usuario' => Usuario::find($request->user()->id), 
    ]);
});

Route::middleware('auth:sanctum')->post('/logout', function (Request $request) {
    $request->user()->currentAccessToken()->delete();

    return response()->json([
        'mensaje' => 'Sesión cerrada exitosamente.'
    ]);
});

Route::post('/login', [ApiControllerUsuario::class, 'iniciarSesion']);

Route::controller(ApiControllerUsuario::class)->group(function () {
    Route::post('/crearUsuario', 'store');
    Route::post('/buscarUsuario', 'buscarUsuario');
    Route::post('/reset', 'cambiarPassword');

    
});

Route::middleware('auth:sanctum')->controller(ApiControllerUbicacion::class)->group(function () {
        Route::post('/guardarUbicacion', 'store');
        Route::post('/guardar-noti', 'guardarNotificacion');
        Route::post('/update-noti', 'actualizarNotificacion');

});

Route::post('/guardar-horario',[ApiControllerUbicacion::class,'guardarHorario']);