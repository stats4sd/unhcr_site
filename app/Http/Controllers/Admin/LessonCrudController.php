<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\LessonRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Illuminate\Support\Facades\Request;

/**
 * Class LessonCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class LessonCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation { store as traitStore; }
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Lesson');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/lesson');
        $this->crud->setEntityNameStrings('lesson', 'lessons');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setFromDb();
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(LessonRequest::class);

        // TODO: remove setFromDb() and manually define Fields
        $this->crud->addFields([
            [
                'type' => 'custom_html',
                'name' => 'main_title',
                'value' => '<h4>Create the lesson Page</h4>'
            ],
            [
                'type' => 'text',
                'name' => 'title',
                'label' => 'Lesson title',
            ],
            [
                'name' => 'image_background',
                'label' => 'Image background',
                'type' => 'upload',
                'upload' => true,
                'disk' => 'uploads',
            ],
            [
                'type' => 'text',
                'name' => 'comment',
                'label' => 'Insert a short descrition for the lesson page',
            ],
            [
                'type' => 'text',
                'name' => 'card',
                'label' => 'Insert a short note for the right card',
            ],
            [   
                'name' => 'body_1',
                'label' => 'Body 1',
                'type' => 'textarea',
            ],
            [
                'name' => 'table_title_1',
                'label' => 'Table title 1',
                'type' => 'text',
            ],
            [
                'name' => 'table_body_1',
                'label' => 'Table Body 1 ',
                'type' => 'table',
                'entity_singular' => 'option', // used on the "Add X" button
                'columns' => [
                    'option1' => 'Option 1',
                    'option2' => 'Option 2',
                    'option3' => 'Option 3',
                    'option4' => 'Option 4',
                    'option5' => 'Option 5',
                ],
                'max' => 20, // maximum rows allowed in the table
                'min' => 0, // minimum rows allowed in the table
            ],
            [
                'name' => 'image_1',
                'label' => 'Image body 1',
                'type' => 'upload',
                'upload' => true,
                'disk' => 'uploads',
            ],
            [   
                'name' => 'body_2',
                'label' => 'Body 2',
                'type' => 'textarea',
            ],
            [
                'name' => 'table_title_2',
                'label' => 'Table title 2',
                'type' => 'text',
            ],
            [
                'name' => 'table_body_2',
                'label' => 'Table Body 2 ',
                'type' => 'table',
                'entity_singular' => 'option', // used on the "Add X" button
                'columns' => [
                    'option1' => 'Option 1',
                    'option2' => 'Option 2',
                    'option3' => 'Option 3',
                    'option4' => 'Option 4',
                    'option5' => 'Option 5',
                ],
                'max' => 20, // maximum rows allowed in the table
                'min' => 0, // minimum rows allowed in the table
            ],
            [
                'name' => 'image_2',
                'label' => 'Image body 2',
                'type' => 'upload',
                'upload' => true,
                'disk' => 'uploads',
            ],
            [   
                'name' => 'body_3',
                'label' => 'Body 3',
                'type' => 'textarea',
            ],
            [
                'name' => 'table_title_3',
                'label' => 'Table title 3',
                'type' => 'text',
            ],
            [
                'name' => 'table_body_3',
                'label' => 'Table Body 3 ',
                'type' => 'table',
                'entity_singular' => 'option', // used on the "Add X" button
                'columns' => [
                    'option1' => 'Option 1',
                    'option2' => 'Option 2',
                    'option3' => 'Option 3',
                    'option4' => 'Option 4',
                    'option5' => 'Option 5',
                ],
                'max' => 20, // maximum rows allowed in the table
                'min' => 0, // minimum rows allowed in the table
            ],
            [
                'name' => 'image_3',
                'label' => 'Image body 3',
                'type' => 'upload',
                'upload' => true,
                'disk' => 'uploads',
            ]
                       
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }

}
