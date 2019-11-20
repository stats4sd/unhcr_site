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
	  	<div class="jumbotron" style="margin-bottom:0, padding: 100px 50px;">
	  		<h1 class="center">Map out the agreements between UNHCR offices and governments</h1>
		</div>
		<div class="row">
			<div class="col-sm-8" style="padding: 100px 100px;"> 
      		<section class="content mb-5 " id="lessons">
      			<p><b>The situation differs a lot between countries and UNHCR departments. As mentioned above, this all seems quite ad-hoc and not formalised or recorded.</b></p>
				<p><b>The groups who are best placed to collect data or support data collection are not the ones using SDG indicators.</b></p>
	        	<p>UNHCR departments like WASH have groups in host countries supporting data collection, but they are concerned with more specialised information, rather than the SDG indicators, which are more relevant at the level of international politics. 
				The indicators don’t map exactly to data used by these projects. WASH collects different data but can ‘convert’ it to give a value for SDG indicators. We may find that other groups do something similar. 
				</p>
				<p><b>The Continuous DHS being conducted in Peru may make an interesting case study</b></p>
				<p>Data is collected annually. More information is available here: <a>https://dhsprogram.com/pubs/pdf/OP8/OP8.pdf</a></p>
	        	<p><b>Table 1.1 Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy</b></p>
	        	<img src="images/table.gif" style="width:60%"  class="center mb-3"/>
	        	<p><b>Getting sufficient information on FDPs is partly reliant on having the right questions, but also on them being included at all in the sampling frame.</b>
				If you can filter down to FDPs, sample sizes are sometimes too small. We need to look at sampling strata and refugee clustering.
				</p>
	        	<p><b>Image 1.1 Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy</b></p>
	        	<img src="images/linechart.png" style="width:60%"  class="center mb-3"/>
	        	<p><b>DHS and MICS have been a more helpful source than initially expected.</b></p>
	        	<p>A few countries (Jordan, Iraq, Columbia) do seem to provide data that can be disaggregated. 
				DHS have been particularly quick to get back to us and give access. 
				We still have some questions to be answered regarding specific datasets. 
				</p>
				<p><b>There are still significant challenges, however.</b></p>
				<p>Most DHS data we accessed was not able to be disaggregated by FDP status, or had too small a sample size once filtered to be useable. 
				One country (Iraq) had a question which identified refugees. Not yet sure if this is listed as an optional question on the DHS survey. This is not formalised or even suggested in SDG indicator guidance.
				Information about the SDG indicators is not always easy to come by. To calculate the infant mortality rate, lots of R scripting work was required.
				</p>
				<p><b>Other data sources</b></p>
				<p>Outside of countrywide surveys, other sources provide useful but limited information. For example, there is education data from specific initiatives, but this will be incomplete and not necessarily representative of the FDP population more broadly as it only involves people from that specific project – this will likely be the case for other areas as well. </p>
			</section>
			</div>
			<div class="col-sm-4" style="padding: 100px 100px;">
				<div class="card" style="height: 300px;">
		          	<div class="card-body">
		            	<h2 class="card-title" style="border-bottom: solid 1px;" ></h2>
		            	<p class="card-text">Indicators are not always recorded at the country level.
						Sometimes the population is at camp level, or other geography. It is important to include this information in reporting.
						</p>
		          	</div>
        		</div>
			</div>
		</div>

</body>
@endsection

@section('footer')
@endsection
