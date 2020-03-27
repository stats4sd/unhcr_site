<?php

namespace App\Models;

use App\User;
use App\Models\Indicator;
use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Script extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'scripts';
    // protected $primaryKey = 'id';
    // public $timestamps = false;
    protected $guarded = ['id'];
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];
    protected $casts = [
        'script_file' => 'array',
        'indicators_calculated' => 'array'
    ];

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
    //One to Many

    public function users()
    {
        return $this->belongsTo('App\User', 'name');
    }

    public function indicators()
    {
        return $this->belongsToMany('App\Models\Indicator');
    }

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

    public function getIndicatorsCalculatedAttribute()
    {
        $indicators = $this->indicators;
        $sdgs = [];
        foreach ($indicators as $indicator) {
            array_push($sdgs, $indicator->sdg_indicator->code);
        }
            $sdg_list<-array_unique($sdgs);
        return $sdg_list;
    }

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */


    public function setScriptFileAttribute($value)
    {
        $attribute_name = "script_file";
        $disk = "public";
        $destination_path = "script";

        $this->uploadMultipleFilesToDisk($value, $attribute_name, $disk, $destination_path);
    }
}
