<?php

namespace App\Http\Controllers\Admin;

use App\User;
use App\Models\Indicator;
use App\Http\Requests\ScriptRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ScriptCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ScriptCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Script');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/script');
        $this->crud->setEntityNameStrings('script', 'scripts');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        #$this->crud->setFromDb();
        $this->crud->addColumns([
            [
                'name' => 'title',
                'label' => 'Title',
                'type' => 'text'
            ],
            [
                'name' => 'author_id',
                'label' => 'Author',
                'type' => 'select',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ],
            [
                'name' => 'location',
                'label' => 'Location',
                'type' => 'text'
            ],
            [
                'name' => 'indicators_calculated',
                'label' => 'SGD Indicators Calculated',
                'type' => 'select_multiple',
                'entity' => 'sdg_indicators',
                'attribute' => 'code',
                'model' => Indicator::class
            ],
            [
                'name' => 'groups_id',
                'label' => 'Groups',
                'type' => 'select',
                'entity' => 'groups',
                'attribute' => 'name',
                'model' => Indicator::class
            ],
            [
                'name' => 'script_file',
                'label' => 'Scripts',
                'type' => 'text'
            ],


        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(ScriptRequest::class);

        $this->crud->addFields([
           
            [
                'name' => 'author_id',
                'label' => 'Select the author of the script',
                'type' => 'select2',
                'entity' => 'users',
                'attribute' => 'name',
                'model' => User::class
            ],
            [
                'name' => 'location',
                'label' => 'Location',
                'type' => 'text'
            ],
            [
                'name' => 'indicators_calculated',
                'label' => 'SGD Indicators Calculated',
                'type' => 'select2_multiple',
                'entity' => 'sdg_indicators',
                'attribute' => 'code',
                'model' => Indicator::class,
                'pivot' => true, 
            ],
            [
                'name' => 'groups_id',
                'label' => 'Groups',
                'type' => 'select2_multiple',
                'entity' => 'groups',
                'attribute' => 'name',
                'model' => Indicator::class
            ],
            [
                'name' => 'script_file',
                'type' => 'upload_multiple',
                'label' => 'If the scripts used to generate the linked indicators are available online, enter the url where they can be found',
                'upload' => true,
            ]

        ]);

    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
