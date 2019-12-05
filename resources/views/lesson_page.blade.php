@extends('layouts.app')
@section('content')
<style type="text/css">
	.lesson_page {
            background: url('{{$lesson_page->image}}') center center / cover no-repeat;
        }
</style>
<body>
<div class="jumbotron lesson_page text-center" style="margin-bottom:0">
	<h1 style="color: white;">{{$lesson_page->title}}</h1>
</div>

<div class="row">
	<div class="col-sm-8 center" style="padding: 100px 100px;">
	    <section class="content mb-5" id="introduction">
		        <p><b>{{ $lesson_page->comment }}</b></p>
		        <p>{{ $lesson_page->body_1 }}</p>
		        @if( $lesson_page->table_title!=null )
		        <div class="w3-container">
	  				<hr>
	  					<div class="w3-center">
	    					<p w3-class="w3-large"><b>Table 1.1 {{ $lesson_page->table_title }}</b></p>
	  					</div>
					<div class="w3-responsive w3-card-4">
					<table class="w3-table w3-striped w3-bordered">
						<thead>
							<tr class="w3-theme">
								<th>First Name</th>
								<th>Last Name</th>
								<th>Points</th>
							</tr>
						</thead>
						<tbody>
						<tr>
							<td>Jill</td>
							<td>Smith</td>
							<td>50</td>
						</tr>
						<tr class="w3-white">
						   	<td>Eve</td>
						  	<td>Jackson</td>
						  	<td>94</td>
						</tr>
						<tr>
						  	<td>Adam</td>
						  	<td>Johnson</td>
						  	<td>67</td>
						</tr>
						</tbody>
					</table>
					</div>
					<hr>
				</div>
				@endif
				<p>{{ $lesson_page->body_2 }}</p>
	    </section>
	</div>
	@if ($lesson_page->card!=null)
	<div class="col-sm-4" style="padding: 100px 100px;">
		<div class="card" style="height: 300px;">
		    <div class="card-body">
		    <h2 class="card-title" style="border-bottom: solid 1px;" ></h2>
		    <p class="card-text">{{ $lesson_page->card}}</p>
		    </div>
        </div>
	</div>
	@endif

</div>
</body>
@endsection

@section('footer')
@endsection