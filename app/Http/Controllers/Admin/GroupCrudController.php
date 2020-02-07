<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\GroupRequest;
use App\Models\Subgroup;
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
                'name' => 'subgroup_id',
                'label' => 'Subgroup',
                'type' => 'select',
                'entity' => 'subgroups',
                'attribute' => 'name',
                'model' => Subgroup::class
            ],
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
                'name' => 'subgroup_id',
                'label' => 'Subgroup',
                'type' => 'select2',
                'entity' => 'subgroups',
                'attribute' => 'name',
                'model' => Subgroup::class
            ],
        ]);

    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
