<?php

$query = $_GET['q'];
$file = './cache/'.$query.'.json';

if(file_exists($file)) {
	$out = file_get_contents($file);
} else {
	$out = file_get_contents('http://gamli.ja.is/kort/search_json/?q='.urlencode($query));
	file_put_contents($file, $out);
}

$callback = empty($_GET['callback']) ? null : $_GET['callback'];

if($callback) {
	// JSONP
	header('Content-Type: application/javascript');
	echo $callback.'('.$out.')';
} else {
	// JSON
	header('Content-Type: application/json');
	echo $out;
}
