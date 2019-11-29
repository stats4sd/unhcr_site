<!-- This file is used to store sidebar items, starting with Backpack\Base 0.9.0 -->
<li class="nav-item"><a class="nav-link" href="{{ backpack_url('dashboard') }}"><i class="fa fa-dashboard nav-icon"></i> {{ trans('backpack::base.dashboard') }}</a></li>
<h5 style="color: lightgrey; padding-left: 10px">Data</h5>
<li class='nav-item'><a class='nav-link' href="{{ backpack_url('dataset') }}"><i class='nav-icon fa fa-list-alt'></i> Datasets</a></li>
<li class='nav-item'><a class='nav-link' href="{{ backpack_url('indicator') }}"><i class='nav-icon 	fa fa-list-ol'></i> Indicators</a></li>
<li class='nav-item'><a class='nav-link' href="{{ backpack_url('comment') }}"><i class='nav-icon fa fa-comments-o'></i> Comments</a></li>

<h5 style="color: lightgrey; padding-left: 10px">WebPage</h5>
<li class='nav-item'><a class='nav-link' href="{{ backpack_url('home') }}"><i class='nav-icon fa fa-file-text'></i> Home Page</a></li>
<li class='nav-item'><a class='nav-link' href="{{ backpack_url('lesson') }}"><i class='nav-icon fa fa-institution'></i> Lessons Page</a></li>

<h5 style="color: lightgrey; padding-left: 10px">Tables</h5>
<li class='nav-item'><a class='nav-link' href='{{ backpack_url('sdgindicator') }}'><i class='nav-icon fa fa-paper-plane-o'></i> Sdg Indicators</a></li>
<li class='nav-item'><a class='nav-link' href='{{ backpack_url('group') }}'><i class='nav-icon fa fa-group'></i> Groups</a></li>

<!-- <li class='nav-item'><a class='nav-link' href='{{ backpack_url('country') }}'><i class='nav-icon fa fa-question'></i> Countries</a></li> -->