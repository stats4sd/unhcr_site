@extends('layouts.app')

@section('content')

 
<div class="header">
    <img src="images/iraq-children.jpg" id="image_home_page"/>
    <div class="text-block">
        SDG Indicators Disaggregated by Forcibly Displaced Populations
    </div>
</div>

<div class="col-sm-12" style="padding-left: 150px; padding-right: 150px;">

      <section class="content mt-5 mb-5">
        <h1><b>Introduction</b></h1>
        <p><b>In 2017, the international community made significant progress with the adoption of the <a style="color:#0072BC;" href="https://unstats.un.org/sdgs/indicators/indicators-list/">SDG framework</a> to guide and assess our progress towards development.</b> UNHCR, national partners and international agencies started a process towards making estimates available of SDG indicators for refugees, internally displaced populations (IDPs) and other forcibly displaced groups. It is expected that work on harmonisation, the adaptation of methodologies, capacity building and publication of disaggregated statistics will increase in the near future.</p>
        <p>This website presents the early results of exploring the availability of micro-data and published statistics about 12 priority SDG indicators for Refugees and IDPs. The SDG indicators page shows the first countries where SDG indicators have been found from an initial exploration of publicly available data. They come from large-scale surveys and from administrative data. The statistics shown are not the result of an exhaustive search and are by no means a reflection of the data available worldwide. We expect that a more complete database may be available as the collaboration between national statistical systems and international agencies continues.</p>
        <p>We welcome feedback, suggestions and contributions of data. Please contact us at <a style="color:#0072BC;" href="hello@stats4sd.org">hello (at) stats4sd.org</a>.</p>


      </section>


  </div>


<div class="row">
    @foreach($cards as $card)
    <div class="col-sm-4">
        <div class="card" style="height: 300px;">
          <div class="card-body">
            <h2 class="card-title" style="border-bottom: solid 1px;" >{{$card->card_title}}</h2>
            <p class="card-text">{{$card->card_body}}</p>
          </div>
        </div>
    </div>
    @endforeach
</div>




@endsection

@section('footer')
@endsection
</body>
</html>

