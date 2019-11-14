@extends('layouts.app')

@section('navbar')
<body>
<div style="padding: 14px 20px;">
  	<div class="row">
    	<div class="col-sm-4">
	    	<h2>About Me</h2>
	      	<h5>Photo of me:</h5>
	      	<div>
	      		<img src="images/linechart.png" style="width:100%"/>
	      	</div>
	      	<p>Some text about me in culpa qui officia deserunt mollit anim..</p>
	      	<h3>Some Links</h3>
	      	<p>Lorem ipsum dolor sit ame.</p>
	      	<ul class="nav nav-pills flex-column">
	        	<li class="nav-item">
	          		<a class="nav-link active" href="#">Active</a>
	        	</li>
	        	<li class="nav-item">
	          		<a class="nav-link" href="#">Link</a>
	        	</li>
	        	<li class="nav-item">
	          		<a class="nav-link" href="#">Link</a>
	        	</li>
	        	<li class="nav-item">
	          		<a class="nav-link disabled" href="#">Disabled</a>
	        	</li>
	      	</ul>
	      	<hr class="d-sm-none">
	    </div>
	    <div class="col-sm-8">
	      	<h2>TITLE HEADING</h2>
	      	<h5>Title description, Dec 7, 2017</h5>
	      	<div class="">
	      		<canvas id="line-chart" width="400" height="400"></canvas>
	      	</div>
	      	<p>Some text..</p>
	      	<p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
	      	<br>
	      	<h2>TITLE HEADING</h2>
	      	<h5>Title description, Sep 2, 2017</h5>
	      	<div class="fakeimg">
	      	<table class="table table-bordered" id="users-table">
		        <thead>
		            <tr>
		                <th>Id</th>
		                <th>Name</th>
		                <th>Email</th>
		                <th>Created At</th>
		                <th>Updated At</th>
		            </tr>
		        </thead>
		    </table>

	      	</div>
	      	<p>Some text..</p>
	      	<p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
	    </div>
	</div>
</div>


@endsection


@section('footer')
@endsection
</body>
</html>

@section('after_scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>

<script type="text/javascript">
jQuery(document).ready(function(){
$(function() {
    $('#users-table').DataTable({
        processing: true,
        serverSide: true,
        ajax: '{!! route('ChartControllerAnyData') !!}',
        columns: [
            { data: 'id', name: 'id' },
            { data: 'name', name: 'name' },
            { data: 'email', name: 'email' },
            { data: 'created_at', name: 'created_at' },
            { data: 'updated_at', name: 'updated_at' }
        ]
    });
});
});
jQuery(document).ready(function(){
	var ctx = document.getElementById("line-chart");
	console.log(ctx);
	new Chart(ctx, {
	  type: 'line',
	  data: {
	    labels: [1500,1600,1700,1750,1800,1850,1900,1950,1999,2050],
	    datasets: [{ 
	        data: [86,114,106,106,107,111,133,221,783,2478],
	        label: "Africa",
	        borderColor: "#3e95cd",
	        fill: false
	      }, { 
	        data: [282,350,411,502,635,809,947,1402,3700,5267],
	        label: "Asia",
	        borderColor: "#8e5ea2",
	        fill: false
	      }, { 
	        data: [168,170,178,190,203,276,408,547,675,734],
	        label: "Europe",
	        borderColor: "#3cba9f",
	        fill: false
	      }, { 
	        data: [40,20,10,16,24,38,74,167,508,784],
	        label: "Latin America",
	        borderColor: "#e8c3b9",
	        fill: false
	      }, { 
	        data: [6,3,2,2,7,26,82,172,312,433],
	        label: "North America",
	        borderColor: "#c45850",
	        fill: false
	      }
	    ]
	  },
	  options: {
	    title: {
	      display: true,
	      text: 'World population per region (in millions)'
	    }
	  }
	});
});
</script>
@endsection