<!DOCTYPE html>
<html lang="en">
<head>
<title>Page Title</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<!-- W3schools -->
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-black.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css">
 <!-- jQuery -->
<script src="//code.jquery.com/jquery.js"></script>
<!-- DataTables -->
<script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<style>

/* Style the body */
body {
  font-family: Arial, Helvetica, sans-serif;
  margin: 0;
}

/* Header/logo Title */
.header {
  /*text-align: center;*/
  background: #1abc9c;
  color: black;
}

/* Increase the font size of the heading */
.header h1 {
  font-size: 40px;
}

/* Sticky navbar - toggles between relative and fixed, depending on the scroll position. It is positioned relative until a given offset position is met in the viewport - then it "sticks" in place (like position:fixed). The sticky value is not supported in IE or Edge 15 and earlier versions. However, for these versions the navbar will inherit default position */
.navbar {
 /* overflow: hidden;*/
  background-color: white;
  position: sticky;
  position: -webkit-sticky;
  top: 0;
}

/* Style the navigation bar links */
.navbar a {
  float: left;
  display: block;
  color: black;
  text-align: center;
  padding: 14px 20px;
  text-decoration: none;
}


/* Right-aligned link */
.navbar a.right {
  float: right;
}

/* Change color on hover */
.navbar a:hover {
  background-color: #0072BC;
  color: white;
}

/* Active/current link */
.navbar a.active {
  background-color: #0072BC;
  color: white;
}

/* Column container */
.row {
  display: -ms-flexbox; /* IE10 */
  display: flex;
  -ms-flex-wrap: wrap; /* IE10 */
  flex-wrap: wrap;
}

/* Create two unequal columns that sits next to each other */
/* Sidebar/left column */
.side {
  -ms-flex: 30%; /* IE10 */
  flex: 30%;
  background-color: #f1f1f1;
  padding: 20px;
}

/* Main column */
.main {
  -ms-flex: 70%; /* IE10 */
  flex: 70%;
  background-color: white;
  padding: 20px;
}



/* Responsive layout - when the screen is less than 700px wide, make the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 700px) {
  .row {
    flex-direction: column;
  }
}

/* Responsive layout - when the screen is less than 400px wide, make the navigation links stack on top of each other instead of next to each other */
@media screen and (max-width: 400px) {
  .navbar a {
    float: none;
    width: 100%;
  }
}

/*-------------
    Home page
-------------*/

/* Container holding the image and the text */
.container {
  position: relative;
}

/* Bottom right text */
.text-block {
  position: absolute;
  bottom: 20px;
  left: 20px;
  color: white;
  padding-left: 20px;
  padding-right: 20px;
}

* {
  box-sizing: border-box;
}

body {
  font-family: Arial, Helvetica, sans-serif;
}



/* Style the counter cards */
.card {
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);  /*this adds the "card" effect */
  padding: 16px;
  background-color: #f1f1f1;
}

/*
------------------------
Lessons & Learning
------------------------
*/

.lessons_top {
            background: url('/images/lessons_top.jpg') center center / cover no-repeat;
        }


.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}

/*------------------------
Footer
------------------------*/

.footer {
  /*overflow: hidden;*/
  background-color: #0072BC;
  position: sticky;
  position: -webkit-sticky;
  padding: 20px;
  text-align: center;
  top: 0;
}

</style>
</head>
<body>
    <div class="navbar">
      <a href="{{ url('home') }}"><b>Home</b></a>
      <a href="{{ url('sdgs') }}"><b>SDGs Indicstors</b></a>
      <a href="{{ url('lessons') }}"><b>Lessons & Learning</b></a>
    </div>
@yield('content')


<div class="footer">
  <!-- Add icon library -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- Add font awesome icons -->
    <a href="{{ url('login') }}" class="text">Admin Login</a>


</div>
@yield('footer')
</body>
