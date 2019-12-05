<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\CommentRequest;
use App\Models\Comment;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;
use Spatie\Tags\Tag;

/**
 * Class CommentCrudController
 * @package App\Http\Controllers\Admin
 * @property-read CrudPanel $crud
 */
class CommentCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation {store as traitStore;}
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation {update as traitUpdate;}
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    public function setup()
    {
        $this->crud->setModel('App\Models\Comment');
        $this->crud->setRoute(config('backpack.base.route_prefix') . '/comment');
        $this->crud->setEntityNameStrings('comment', 'comments');
    }

    protected function setupListOperation()
    {
        // TODO: remove setFromDb() and manually define Columns, maybe Filters
        $this->crud->setColumns([
            [
                'name' => 'comment',
                'label' => 'comment',
                'type' => 'text',
                'limit' => 100,
            ],
            [
                'name' => 'tags',
                'label' => 'Tags(s)',
                'type' => 'select_multiple',
                'entity' => 'tags',
                'attribute' => 'name',
                'model' => Tag::class
            ],
        ]);

        $this->crud->addFilter(
            [
                'type' => 'select2_multiple',
                'name' => 'tags',
                'label' => 'filter by tag',
            ], function() {
                return Tag::get()->pluck('name','id')->toArray();
            }, function($values) {
                foreach(json_decode($values) as $key => $value) {

                    $this->crud->query = $this->crud->query->whereHas('tags', function($q) use ($value) {
                        $q->where('tags.id', '=', $value);
                    });
                }
            }
        );
    }

    protected function setupCreateOperation()
    {
        $this->crud->setValidation(CommentRequest::class);

        $this->crud->addFields([
            [
                'name' => 'comment',
                'label' => 'Add your comment',
                'type' => 'textarea',
                'attributes' => [
                    'rows' => 8
                ],
            ],
            [
                'name' => 'tags',
                'label' => 'Tag the resource.',
                'type' => 'tags',
                'hint' => 'The dropdown contains the existing tags - start typing to filter them. If the tag you want does not exist, type it in and it will be created on save. Be generous in your tags. Similar tags will be sorted and merged later.',
                'entity' => 'tags',
                'attribute' => 'name',
                'model' => Tag::class,
                //'pivot' => true,
                'select2_attributes' => [
                    'tags' => true
                ],
            ],
        ]);
    }

    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }

    public function store ()
    {
        $tags = $this->request->spatie_tags;

        $redirect_location = $this->traitStore();

        $comment = Comment::find($this->data['entry']['id']);

        $this->handleTags($tags, $comment);

        return $redirect_location;
    }

    public function update ()
    {
        $tags = $this->request->spatie_tags;

        $redirect_location = $this->traitUpdate();

        $comment = Comment::find($this->data['entry']['id']);

        $this->handleTags($tags, $comment);

        return $redirect_location;
    }

    public function handleTags ($tags, $comment)
    {
        $comment->syncTags($tags);
    }
}
