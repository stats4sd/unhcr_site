<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class LinkScriptsSdgIndicatorsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('link_scripts_indicators', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->integer('script_id')->unsigned();
            $table->foreign('script_id')->references('id')->on('scripts');
            $table->integer('indicator_id');
            $table->foreign('indicator_id')->references('id')->on('indicators');
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
