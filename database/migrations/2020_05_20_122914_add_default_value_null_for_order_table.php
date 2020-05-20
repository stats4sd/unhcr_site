<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddDefaultValueNullForOrderTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('sdg_indicators', function (Blueprint $table) {
            $table->integer('lft')->default(0)->change();
            $table->integer('rgt')->default(0)->change();
            $table->integer('depth')->default(0)->change();
        });
        Schema::table('subgroups', function (Blueprint $table) {
            $table->integer('lft')->default(0)->change();
            $table->integer('rgt')->default(0)->change();
            $table->integer('depth')->default(0)->change();
        });
        Schema::table('groups', function (Blueprint $table) {
            $table->integer('lft')->default(0)->change();
            $table->integer('rgt')->default(0)->change();
            $table->integer('depth')->default(0)->change();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
