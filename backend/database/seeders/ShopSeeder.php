<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;

class ShopSeeder extends Seeder
{
    public function run(): void
    {
        // Categories
        $groceries = Category::create(['name' => 'Groceries', 'type' => 'grocery']);
        $clothes = Category::create(['name' => 'Clothes', 'type' => 'clothes']);

        // Products - Groceries
        Product::create([
            'category_id' => $groceries->id,
            'name' => 'Afghan Rice (Palaw)',
            'description' => 'Premium quality Sela rice for Palaw.',
            'price' => 1200, // AFN
            'stock' => 50,
        ]);
        Product::create([
            'category_id' => $groceries->id,
            'name' => 'Green Tea',
            'description' => 'Traditional refreshing green tea.',
            'price' => 300,
            'stock' => 100,
        ]);

        // Products - Clothes
        Product::create([
            'category_id' => $clothes->id,
            'name' => 'Perahan Tunban (Men)',
            'description' => 'Traditional Afghan clothing for men.',
            'price' => 2500,
            'stock' => 20,
        ]);
         Product::create([
            'category_id' => $clothes->id,
            'name' => 'Gand-e-Afghani (Women)',
            'description' => 'Colorful traditional dress for special occasions.',
            'price' => 5000,
            'stock' => 10,
        ]);
    }
}
