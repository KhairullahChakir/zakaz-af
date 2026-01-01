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
        Schema::create('app_settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->string('type')->default('string'); // string, json, boolean
            $table->string('group')->default('general'); // contact, social, about
            $table->timestamps();
        });

        // Insert default settings
        DB::table('app_settings')->insert([
            // Contact Info
            ['key' => 'contact_email', 'value' => 'khairullahanosh9626@gmail.com', 'type' => 'string', 'group' => 'contact', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'contact_phone', 'value' => '+77073756623', 'type' => 'string', 'group' => 'contact', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'contact_whatsapp', 'value' => '+77073756623', 'type' => 'string', 'group' => 'contact', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'contact_location', 'value' => 'Sheberghan, Jawzjan, Afghanistan', 'type' => 'string', 'group' => 'contact', 'created_at' => now(), 'updated_at' => now()],
            
            // Social Media Links
            ['key' => 'social_facebook', 'value' => '', 'type' => 'string', 'group' => 'social', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'social_instagram', 'value' => '', 'type' => 'string', 'group' => 'social', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'social_tiktok', 'value' => '', 'type' => 'string', 'group' => 'social', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'social_telegram', 'value' => '', 'type' => 'string', 'group' => 'social', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'social_youtube', 'value' => '', 'type' => 'string', 'group' => 'social', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_settings');
    }
};
