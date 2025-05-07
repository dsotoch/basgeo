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
        User::create([
            'name'=>'Josue Misericordia',
            'email'=>'josue@gmail.com',
            'password'=>password_hash('josue1813',PASSWORD_DEFAULT),
        ]);

        Usuario::create([
            'nombre' => 'Josue',
            'apellidos' => 'Misericordia',
            'tipo' => 'admin',
            'direccion' => 'Las Palmeras',
        ]);
    }
}
