<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLessonsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('lessons', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title');
            $table->text('image_background');
            $table->string('slug');
            $table->text('comment')->nullable();
            $table->longText('body_1');
            $table->text('table_title_1')->nullable();
            $table->text('table_body_1')->nullable();
            $table->string('image_1')->nullable();
            $table->longText('body_2')->nullable();
            $table->text('table_title_2')->nullable();
            $table->text('table_body_2')->nullable();
            $table->string('image_2')->nullable();
            $table->longText('body_3')->nullable();
            $table->text('table_title_3')->nullable();
            $table->text('table_body_3')->nullable();
            $table->string('image_3')->nullable();
            $table->longText('card')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('lessons_page');
    }
}
