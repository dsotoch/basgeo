<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Usuario;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class ApiControllerUsuario extends Controller
{
    public function store(Request $request)
    {
        // Validación fuera del try
        try {
            $validated = $request->validate([
                'nombre' => 'required',
                'apellidos' => 'required',
                'tipo' => 'required',
                'direccion' => 'required',
                'email' => 'required|email|unique:users,email',
                'password' => 'required',
                'name' => 'required'
            ]);
        } catch (ValidationException $e) {
            throw new HttpResponseException(response()->json([
                'codigo' => 422,
                'mensaje' => 'Completa todos los campos.',
                'errores' => $e->errors(),
            ], 422));
        }

        try {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => bcrypt($validated['password']),
            ]);
            $usuario = Usuario::create([
                'nombre' => $validated['nombre'],
                'apellidos' => $validated['apellidos'],
                'tipo' => $validated['tipo'],
                'direccion' => $validated['direccion'],
                'user_id' => $user->id
            ]);



            return response()->json(['mensaje' => $usuario], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'mensaje' => 'Ocurrió un error: ' . $th->getMessage()
            ], 500);
        }
    }

    public function iniciarSesion(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required',
                'password' => 'required'
            ]);

            $email = $request->input('email');
            $password = $request->input('password');
            $usuario = User::where('email', $email)->first();
            if (! $usuario || ! Hash::check($password, $usuario->password)) {
                return response()->json(['mensaje' => 'Credenciales inválidas'], 401);
            }

            return response()->json([
                'token' => $usuario->createToken('api-token')->plainTextToken,
            ], 200);
        } catch (\Throwable $th) {
            return response()->json(['mensaje' => 'ocurrio un error:' . $th->getMessage()], 500);
        }
    }

    public function buscarUsuario(Request $request)
    {
        try {
            // Validar que el correo esté presente y sea un correo válido
            $request->validate([
                'email' => 'required|email',
            ]);

            // Obtener el correo electrónico del request
            $usuario = $request->input('email');

            // Buscar el usuario por correo
            $usuario_encontrado = User::where('email', $usuario)->first();

            // Verificar si el usuario fue encontrado
            if ($usuario_encontrado) {
                return response()->json([
                    "mensaje" => $usuario_encontrado->id,
                ], 200);
            }

            // Respuesta si el usuario no existe
            return response()->json([
                "mensaje" => "No existe una cuenta registrada con ese correo.",
            ], 404);
        } catch (\Illuminate\Validation\ValidationException $e) {
            // Manejo de errores de validación
            return response()->json([
                "mensaje" => "Error de validación",
                "errores" => $e->errors(),
            ], 422);
        } catch (\Throwable $th) {
            // Manejo de errores generales
            return response()->json([
                "mensaje" => "Error del servidor",
                "detalle" => $th->getMessage(),
            ], 500);
        }
    }

    public function cambiarPassword(Request $request)
    {
        try {
            $usuario = User::find($request->id);
            $usuario->update(['password' => password_hash($request->password, PASSWORD_DEFAULT)]);
            return response()->json(['mensaje' => "Contraseña modificada correctamente."], 200);
        } catch (\Throwable $th) {
            return response()->json(['mensaje' => $th->getMessage()], 500);
        }
    }
}
