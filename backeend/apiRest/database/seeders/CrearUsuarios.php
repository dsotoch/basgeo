<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Usuario;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class CrearUsuarios extends Seeder
{
    /**
     * Run the database seeds.
     */
   public function run(): void
    {
        // Crear usuario 1
        $user1 = User::create([
            'name' => 'Josue Misericordia',
            'email' => 'josue@gmail.com',
            'password' => Hash::make('josue1813'),
        ]);

        // Crear registro en usuarios (tabla usuarios)
        Usuario::create([
            'nombre' => 'Josue',
            'apellidos' => 'Misericordia',
            'tipo' => 'cliente',
            'direccion' => 'Las Palmeras',
            // Si tienes relación con user_id, agrega aquí
            // 'user_id' => $user1->id,
        ]);

        // Crear usuario 2
        $user2 = User::create([
            'name' => 'Repartidor Sanches',
            'email' => 'repartidor@gmail.com',
            'password' => Hash::make('repartidor1813'),
        ]);

        // Crear registro en usuarios (tabla usuarios)
        Usuario::create([
            'nombre' => 'Repartidor',
            'apellidos' => 'Sanches',
            'tipo' => 'repartidor',
            'direccion' => 'Las Palmeras',
            // 'user_id' => $user2->id,
        ]);
    }
}
