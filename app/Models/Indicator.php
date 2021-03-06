<?php

namespace App\Models;

use App\Models\Dataset;
use App\Models\Group;
use App\Models\SdgIndicator;
use App\Models\Subgroup;
use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Model;

class Indicator extends Model
{
    use CrudTrait;

    /*
    |--------------------------------------------------------------------------
    | GLOBAL VARIABLES
    |--------------------------------------------------------------------------
    */

    protected $table = 'indicators';
    // protected $primaryKey = 'id';
    // public $timestamps = false;
    protected $guarded = ['id', 'datasets'];
    protected $appends = ['combined_label'];
    // protected $fillable = [];
    // protected $hidden = [];
    // protected $dates = [];

    /*
    |--------------------------------------------------------------------------
    | FUNCTIONS
    |--------------------------------------------------------------------------
    */

    public function getCombinedLabelAttribute ()
    {
        // dataset: sdg_code - group - subgroupname
        $dataset = $this->datasets->description;
        $sdg_code = $this->sdg_indicator->code;
        $group = $this->groups->name;
        $subgroup = $this->subgroups->name;

        return $dataset . ": " . $sdg_code . " - " . $group . " - " . $subgroup;

    }

    //One to Many

    public function datasets()
    {
        return $this->belongsTo('App\Models\Dataset', 'dataset_id');
    }

    public function groups()
    {
        return $this->belongsTo('App\Models\Group', 'group_name');
    }

    public function sdg_indicator()
    {
        return $this->belongsTo('App\Models\SdgIndicator', 'sdg_indicator_id');
    }

    public function subgroups()
    {
        return $this->belongsTo('App\Models\Subgroup', 'subgroup_name');
    }

    //Many to Many
    public function scripts()
    {
        return $this->belongsToMany('App\Models\Script', 'link_scripts_indicators', 'script_id', 'indicator_id');
    }

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
}
