<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\GroupRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class GroupCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class GroupCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ReorderOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Group');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/group');
        $this->crud->setEntityNameStrings('group', 'groups');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setColumns([
            [
                'name' => 'name',
                'label' => 'Name',
                'type' => 'text',
            ],
            [
                'name' => 'lft',
                'label' => 'lft',
                'type' => 'number',
            ],
            [
                'name' => 'rgt',
                'label' => 'rgt',
                'type' => 'number',
            ],
            [
                'name' => 'depth',
                'label' => 'depth',
                'type' => 'number',
            ]     
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(GroupRequest::class);

        $this->crud->addFields([
            [
                'name' => 'name',
                'label' => 'Enter name of group',
                'type' => 'text',
            ],
            [
                'name' => 'lft',
                'label' => 'Enter left number',
                'type' => 'number',
            ],
            [
                'name' => 'rgt',
                'label' => 'Enter right number',
                'type' => 'number',
            ],
            [
                'name' => 'depth',
                'label' => 'Enter depth number',
                'type' => 'number',
            ]
        ]);

    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }

    protected function setupReorderOperation()
    {
        // define which model attribute will be shown on draggable elements 
        $this->crud->set('reorder.label', 'name');
        // define how deep the admin is allowed to nest the items
        // for infinite levels, set it to 0
        $this->crud->set('reorder.max_level', 1);
    }
}
