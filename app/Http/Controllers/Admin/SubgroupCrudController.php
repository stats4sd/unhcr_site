<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\SubgroupRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class SubgroupCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class SubgroupCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Subgroup');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/subgroup');
        $this->crud->setEntityNameStrings('subgroup', 'subgroups');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        //$this->crud->setFromDb();
        $this->crud->addColumns([
            [
                'name' => 'name',
                'label' => 'Subgroup name',
                'type' => 'text',
            ],
            [
                'name' => 'created_at',
                'label' => 'Created at',
                'type' => 'datetime',
            ],
            [
                'name' => 'updated_at',
                'label' => 'Updated at',
                'type' => 'datetime',
            ]
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(SubgroupRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        //$this->crud->setFromDb();
        $this->crud->addColumns([
            [
                'name' => 'name',
                'label' => 'Subgroup name',
                'type' => 'text',
            ]
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
