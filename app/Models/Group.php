<?php

namespace App\Models;

use App\Models\Indicator;
use App\Models\Subgroup;
use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Group extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'groups';
    protected $primaryKey = 'name';
    // public $timestamps = false;
    // protected $guarded = ['id'];
    protected $fillable = ['name', 'subgroup_id'];
    // protected $hidden = [];
    // protected $dates = [];
    public $incrementing = false;
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
    public function indicator()
    {
        return $this->hasMany('App\Models\Indicator');
    }

    public function subgroup()
    {
        return $this->hasMany('App\Models\Subgroup', 'name');
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

    /*
    |--------------------------------------------------------------------------
    | MUTATORS
    |--------------------------------------------------------------------------
    */
}
