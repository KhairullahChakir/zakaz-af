<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Google\Auth\Credentials\ServiceAccountCredentials;
use Illuminate\Support\Facades\Log;
use App\Models\Notification;

class FCMService
{
    /**
     * Send notification to a specific user (DB + Push)
     */
    public static function sendToUser($user, $title, $body, $data = [], $type = 'general')
    {
        // 1. Save to DB
        Notification::create([
            'user_id' => $user->id,
            'title' => $title,
            'body' => $body,
            'type' => $type,
        ]);

        // 2. Send Push
        if ($user->fcm_token) {
            return self::send($user->fcm_token, $title, $body, $data);
        }

        return false;
    }

    /**
     * Send raw FCM push notification using HTTP v1 API
     */
    public static function send($token, $title, $body, $data = [])
    {
        $serviceAccountPath = storage_path('app/firebase-service-account.json');
        
        if (!file_exists($serviceAccountPath)) {
            Log::error('Firebase service account file not found');
            return false;
        }

        try {
            // Get credentials
            $credentials = new ServiceAccountCredentials(
                'https://www.googleapis.com/auth/firebase.messaging',
                json_decode(file_get_contents($serviceAccountPath), true)
            );
            
            // Fetch auth token
            $accessToken = $credentials->fetchAuthToken()['access_token'];
            
            // Get project ID
            $serviceAccount = json_decode(file_get_contents($serviceAccountPath), true);
            $projectId = $serviceAccount['project_id'];

            // Construct message
            $message = [
                'token' => $token,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
            ];

            // Add data payload if exists (must be strings)
            if (!empty($data)) {
                // Ensure all data values are strings for FCM
                $stringData = array_map(function($value) {
                    return (string) $value;
                }, $data);
                $message['data'] = $stringData;
            }

            // Send request
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
                'Content-Type' => 'application/json',
            ])->post("https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send", [
                'message' => $message,
            ]);

            if ($response->successful()) {
                return true;
            } else {
                Log::error('FCM v1 API error: ' . $response->body());
                return false;
            }
        } catch (\Exception $e) {
            Log::error('FCM notification error: ' . $e->getMessage());
            return false;
        }
    }
}
