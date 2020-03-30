<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddScriptDescriptionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('scripts', function (Blueprint $table) {
            $table->text('description');
        });

        Schema::table('datasets', function (Blueprint $table) {
            $table->dropColumn('scripts_url');
            $table->dropColumn('scripts_description');
            $table->integer('script_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('scripts', function (Blueprint $table) {
            //
        });
    }
}
