<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\HomePageCardRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class HomePageCardCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class HomePageCardCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\HomePageCard');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/homepagecard');
        $this->crud->setEntityNameStrings('home page card', 'home page cards');
    }

    protected function setupListOperation()
    {
        $this->crud->addColumns([
            [
                'name' => 'card_title',
                'label' => 'Card-Title',
                'type' => 'text',
                'limit' => 100,
            ],
            [
                'name' => 'card_body',
                'label' => 'Card-Body',
                'type' => 'text',
            ],
        ]);
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(HomePageCardRequest::class);

        $this->crud->addFields([
            [
                'name' => 'card_title',
                'label' => 'Card-Title',
                'type' => 'text',
                'limit' => 100,
            ],
            [
                'name' => 'card_body',
                'label' => 'Card-Body',
                'type' => 'text',
            ],
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
