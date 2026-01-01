<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use Illuminate\Http\Request;

class AppSettingsController extends Controller
{
    /**
     * Get all public app settings (for mobile app)
     */
    public function index()
    {
        $settings = AppSetting::getAllAsArray();
        
        // Structure the response for the mobile app
        return response()->json([
            'success' => true,
            'data' => [
                'contact' => [
                    'email' => $settings['contact_email'] ?? '',
                    'phone' => $settings['contact_phone'] ?? '',
                    'whatsapp' => $settings['contact_whatsapp'] ?? '',
                    'location' => $settings['contact_location'] ?? '',
                ],
                'social' => [
                    'facebook' => $settings['social_facebook'] ?? '',
                    'instagram' => $settings['social_instagram'] ?? '',
                    'tiktok' => $settings['social_tiktok'] ?? '',
                    'telegram' => $settings['social_telegram'] ?? '',
                    'youtube' => $settings['social_youtube'] ?? '',
                ],
            ],
        ]);
    }

    /**
     * Get all settings for admin panel
     */
    public function adminIndex()
    {
        $settings = AppSetting::all();
        return response()->json([
            'success' => true,
            'data' => $settings,
        ]);
    }

    /**
     * Update a setting (Admin only)
     */
    public function update(Request $request, string $key)
    {
        $request->validate([
            'value' => 'nullable|string',
        ]);

        $setting = AppSetting::where('key', $key)->first();
        
        if (!$setting) {
            return response()->json([
                'success' => false,
                'message' => 'Setting not found',
            ], 404);
        }

        $setting->value = $request->value ?? '';
        $setting->save();

        return response()->json([
            'success' => true,
            'message' => 'Setting updated successfully',
            'data' => $setting,
        ]);
    }

    /**
     * Bulk update settings (Admin only)
     */
    public function bulkUpdate(Request $request)
    {
        $request->validate([
            'settings' => 'required|array',
            'settings.*.key' => 'required|string',
            'settings.*.value' => 'nullable|string',
        ]);

        foreach ($request->settings as $item) {
            AppSetting::where('key', $item['key'])->update(['value' => $item['value'] ?? '']);
        }

        return response()->json([
            'success' => true,
            'message' => 'Settings updated successfully',
        ]);
    }
}
