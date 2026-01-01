<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AppSetting extends Model
{
    protected $fillable = ['key', 'value', 'type', 'group'];

    /**
     * Get a setting value by key
     */
    public static function getValue(string $key, $default = null)
    {
        $setting = self::where('key', $key)->first();
        if (!$setting) return $default;
        
        if ($setting->type === 'json') {
            return json_decode($setting->value, true);
        }
        if ($setting->type === 'boolean') {
            return filter_var($setting->value, FILTER_VALIDATE_BOOLEAN);
        }
        return $setting->value;
    }

    /**
     * Set a setting value by key
     */
    public static function setValue(string $key, $value, string $type = 'string', string $group = 'general')
    {
        if ($type === 'json' && is_array($value)) {
            $value = json_encode($value);
        }
        
        return self::updateOrCreate(
            ['key' => $key],
            ['value' => $value, 'type' => $type, 'group' => $group]
        );
    }

    /**
     * Get all settings in a specific group
     */
    public static function getGroup(string $group)
    {
        return self::where('group', $group)->get()->pluck('value', 'key')->toArray();
    }

    /**
     * Get all settings as a key-value array
     */
    public static function getAllAsArray()
    {
        $settings = self::all();
        $result = [];
        
        foreach ($settings as $setting) {
            $value = $setting->value;
            if ($setting->type === 'json') {
                $value = json_decode($value, true);
            } elseif ($setting->type === 'boolean') {
                $value = filter_var($value, FILTER_VALIDATE_BOOLEAN);
            }
            $result[$setting->key] = $value;
        }
        
        return $result;
    }
}
