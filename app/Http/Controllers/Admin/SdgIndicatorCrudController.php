<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\SdgIndicatorRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class SdgIndicatorCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class SdgIndicatorCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    // use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    // use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\SdgIndicator');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/sdgindicator');
        $this->crud->setEntityNameStrings('sdgindicator', 'sdg indicators');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setColumns([
            [
                'name' => 'id',
                'label' => 'Id',
                'type' => 'char',
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'text',
            ],
            [
                'name' => 'created_at',
                'label' => 'created_at',
                'type' => 'dateTime',
            ],
            [
                'name' => 'updated_at',
                'label' => 'updated_at',
                'type' => 'datetime',
            ]
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(SdgIndicatorRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'name' => 'id',
                'label' => 'Id',
                'type' => 'text',     
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'text',
            ]
        ]);
    }

    protected function setupUpdateOperation()
    {
        // $this->setupCreateOperation();
        $this->crud->addFields([
            [
                'name' => 'id',
                'label' => 'Id',
                'type' => 'text',
                'attributes' => [
                    'disabled' => 'disabled'
                ]
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'text',
            ]
        ]);
    }
}
