<?php

namespace App\Models;

use App\Models\Indicator;
use App\Models\Script;
use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class SdgIndicator extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'sdg_indicators';
    protected $primaryKey = 'id';
    // public $timestamps = false;
    // protected $guarded = ['id'];
    protected $fillable = ['id', 'code', 'description'];
    // protected $hidden = [];
    // protected $dates = [];
    public $incrementing = false;
    protected $appends = ['full_lable'];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */
    public function getFullLableAttribute()
    {
        return $this->code . ' ' . $this->description;
    }

    /*
    |--------------------------------------------------------------------------
    | RELATIONS
    |--------------------------------------------------------------------------
    */
    public function indicators()
    {
        return $this->hasMany('App\Models\Indicator', 'sdg_indicator_id');
    }

    public function scripts()
    {
        return $this->belongsToMany('App\Models\Script', 'code');
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
    public function setCodeAttribute($value)
    {
        $this->attributes['id'] = str_replace( '.', '_', $value);
        $this->attributes['code'] = $value;
        return $value;
    }

}
