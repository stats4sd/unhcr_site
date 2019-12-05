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
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\SdgIndicator');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/sdgindicator');
        $this->crud->setEntityNameStrings('sdgindicator', 'sdg indicators');
    }

    protected function setupListOperation()
    {
        $this->crud->setColumns([
            [
                'name' => 'code',
                'label' => 'Code',
                'type' => 'char',
            ],
            [
                'name' => 'description',
                'label' => 'Description',
                'type' => 'text',
                'limit' => 100,
            ],
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(SdgIndicatorRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'name' => 'code',
                'label' => 'Insert code',
                'type' => 'text',
                'hint' => 'Example 2.3.4',
            ],
            [
                'name' => 'description',
                'label' => 'Insert description',
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
                'label' => 'Id (cannot be changed - if this is wrong, please delete and recreate the SDG indicator record)',
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
