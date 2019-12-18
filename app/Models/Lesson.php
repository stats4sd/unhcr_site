<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Lesson extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'lessons';
    // protected $primaryKey = 'id';
    // public $timestamps = false;
    protected $guarded = ['id'];
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | SCOPES
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | ACCESSORS
    |--------------------------------------------------------------------------
    */

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
    public function setTitleAttribute ($value)
    {
        $this->attributes['slug'] = preg_replace('/[^a-z0-9]+/i', '-', trim(strtolower($value)));
         $this->attributes['title'] = $value; 
        return $value;
    }

    public function setImage1Attribute($value)
    {
        $attribute_name = "image_1";
        $disk = "public";
        $destination_path = "images";

        $this->uploadFileToDisk($value, $attribute_name, $disk, $destination_path);
    }

    public function setImageBackgroundAttribute($value)
    {
        $attribute_name = "image_background";
        $disk = "public";
        $destination_path = "images";

        $this->uploadFileToDisk($value, $attribute_name, $disk, $destination_path);
    }

}
