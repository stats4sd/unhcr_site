@extends('layouts.app')
@section('navbar')
<body>
<div class="jumbotron lessons_top text-center" style="margin-bottom:0">
  <h1 style="color: white;">Lessons and Learning</h1>
</div>
	<div class="col-sm-12 center" style="padding: 50px 50px;"> 
      	<section class="content mb-5" id="introduction">
	        <h1 style="text-align:center"><b>Lessons learned</b></h1>
	        <p><b>There is very little data on IDPs and out-of-camp refugees</b></p>
	        <p>This is not new information, but worth bearing in mind when looking at the available data.</p> 
			<p>IDP data collection challenges seem to be due to their being harder to keep track of and less of a priority for data collection groups, as they don’t face the same challenges as refugees, such as language and cultural barriers to integration. 
			Out-of-camp refugees are very hard to collect data about as the situation is extremely sensitive. There is not much realistically that we can recommend to change this.  
			</p>
	        <p><b>Currently, data collected by countries and government projects is unlikely to disaggregate by FDPs unless UNHCR has been working with the groups directly.</b></p>
	        <p>For example, WASH collects high quality data on refugees, but only where its own staff are present. They cannot rely on other groups or government initiatives to collect useful data. If their staff are not present, they don’t get the data. This is all organised through individual relationships in-country. There is not a formal process or systematised approach, and these relationships differ even between groups within UNHCR. </p>
      	</section>
  	</div>
<!-- Topics Cards -->
  	<div class="w3-row-padding w3-center w3-margin-top">
		<div class="w3-third">
			<div class="w3-card w3-container" style="min-height:460px">
				<h3>Topics 1</h3><br>
			  	<i class="fa fa-desktop w3-margin-bottom w3-text-theme" style="font-size:120px"></i>
			  	<p class="center">The situation differs a lot between countries and UNHCR departments. As mentioned above, this all seems quite ad-hoc and not formalised or recorded.</p>
		  	</div>
		</div>

		<div class="w3-third">
			<div class="w3-card w3-container" style="min-height:460px">
				<h3>Topics 2</h3><br>
				<i class="fa fa-database w3-margin-bottom w3-text-theme" style="font-size:120px"></i>
				<p class="center">The situation differs a lot between countries and UNHCR departments. As mentioned above, this all seems quite ad-hoc and not formalised or recorded.</p>
			</div>
		</div>

		<div class="w3-third">
			<div class="w3-card w3-container" style="min-height:460px">
		  		<h3>Topics 3</h3><br>
			  	<i class="fa fa-server w3-margin-bottom w3-text-theme" style="font-size:120px"></i>
			  	<p class="center">The situation differs a lot between countries and UNHCR departments. As mentioned above, this all seems quite ad-hoc and not formalised or recorded.</p>
			</div>
		</div>
	</div>


	<div class="jumbotron" style="margin-bottom:0, padding: 100px 50px;">
	    <h1 class="center">Map out the agreements between UNHCR offices and governments</h1>
	</div>

<!-- Articles lists -->

<!-- !PAGE CONTENT! -->
<div class="w3-main w3-content w3-padding" style="max-width:1200px;margin-top:100px">

  <!-- First Photo Grid-->
  	<div class="w3-row-padding w3-padding-16 w3-center">
  		@foreach ($lessons as $lesson)
    	<div class="w3-quarter">
    		<a href="lessons/{{$lesson->slug}}">
      		<img src="{{$lesson->image}}" alt="Image" style="width:100%">
      		<h3>{{$lesson->title}}</h3>
      		</a>
      		<p>{{$lesson->comment}}</p>
    	</div>
    	@endforeach
  	</div>
  
  	<!-- Pagination -->
  	<div class="w3-center w3-padding-32">
	    <div class="w3-bar">
		    <a href="#" class="w3-bar-item w3-button w3-hover-black">«</a>
		    <a href="#" class="w3-bar-item w3-black w3-button">1</a>
		    <a href="#" class="w3-bar-item w3-button w3-hover-black">2</a>
		    <a href="#" class="w3-bar-item w3-button w3-hover-black">3</a>
		    <a href="#" class="w3-bar-item w3-button w3-hover-black">4</a>
		    <a href="#" class="w3-bar-item w3-button w3-hover-black">»</a>
	    </div>
  	</div>
	</div>

</body>
@endsection

@section('footer')
@endsection
