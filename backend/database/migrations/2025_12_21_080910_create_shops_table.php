<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('shops', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_id')->constrained('users')->cascadeOnDelete();
            
            // Basic Info
            $table->string('name');
            $table->string('type'); // grocery, clothes, electronics, restaurant, etc.
            $table->text('description')->nullable();
            
            // Location
            $table->string('address');
            $table->string('city');
            $table->string('province');
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            
            // Photos (JSON array of image paths)
            $table->json('photos')->nullable();
            
            // Documents
            $table->string('business_license')->nullable(); // Image/PDF of license
            $table->string('owner_nid')->nullable(); // Tazkira image
            
            // Contact
            $table->string('phone');
            $table->string('email')->nullable();
            
            // Status
            $table->enum('status', ['pending', 'approved', 'rejected', 'suspended'])->default('pending');
            $table->text('rejection_reason')->nullable();
            $table->timestamp('approved_at')->nullable();
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shops');
    }
};
